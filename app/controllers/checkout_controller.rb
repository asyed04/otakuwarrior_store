class CheckoutController < ApplicationController
  # Skip caching for all checkout actions
  before_action :set_no_cache
  
  # Force reload of assets
  before_action :set_cache_buster
  def new
    # Force reload to avoid caching issues
    ActiveRecord::Base.connection.clear_query_cache
    
    # Create a new customer object for the form
    if customer_signed_in?
      # For logged-in users, reload the customer to ensure fresh data
      @customer = Customer.find(current_customer.id)
      
      # Log what we found
      Rails.logger.debug "Found customer: #{@customer.inspect}"
      
      # If the customer has no province_id but we're logged in, try to set it
      if @customer.province_id.blank? && current_customer.province_id.present?
        # Try to update the customer record directly
        @customer.update_column(:province_id, current_customer.province_id) if @customer.persisted?
        @customer.province_id = current_customer.province_id
        Rails.logger.debug "Updated province_id to: #{@customer.province_id}"
      end
    else
      # For guests, create a new customer
      @customer = Customer.new
    end
    
    # Get all provinces for the dropdown
    @provinces = Province.all.order(:name)
    
    # Debug output
    Rails.logger.debug "Final customer object: #{@customer.inspect}"
    Rails.logger.debug "Province ID: #{@customer.province_id.inspect}"
    
    # Add a flash message to show we're not using cached data
    flash.now[:notice] = "Page refreshed at #{Time.now.strftime('%H:%M:%S')}"
  end
  
  def simple
    # Just load the provinces for the dropdown
    @provinces = Province.all.order(:name)
    
    # Log that we're using the simple page
    Rails.logger.debug "Using simple checkout page"
  end

  def confirm
    # Log the parameters for debugging
    Rails.logger.debug "Customer params: #{customer_params.inspect}"
    
    # Get customer object based on sign-in status
    @customer = if customer_signed_in?
                  current_customer
                else
                  customer_data = customer_params
                  customer_data[:name] = "Guest" if customer_data[:name].blank?
                  customer_data[:email] = "guest_#{Time.now.to_i}@example.com" if customer_data[:email].blank?
                  Customer.new(customer_data)
                end

    # If user is logged in, update their info without password validation
    if customer_signed_in?
      @customer.assign_attributes(customer_params)
      @customer.save(validate: false)  # Skip validations like password
    else
      # For guests, save the new customer
      unless @customer.save
        flash[:alert] = "Could not save customer information: #{@customer.errors.full_messages.join(', ')}"
        redirect_to checkout_path
        return
      end
    end

    cart = session[:cart] || {}
    if cart.empty?
      flash[:alert] = "Your cart is empty. Please add items before checking out."
      redirect_to store_path
      return
    end

    # Calculate the subtotal
    @subtotal = 0
    cart.each do |product_id, quantity|
      product = Product.find(product_id)
      @subtotal += product.price * quantity.to_i
    end

    # Get the province for tax calculation
    province = Province.find(@customer.province_id)
    
    # Calculate taxes
    gst = @subtotal * (province.gst || 0)
    pst = @subtotal * (province.pst || 0)
    hst = @subtotal * (province.hst || 0)
    
    # Calculate the total
    @total = @subtotal + gst + pst + hst
    
    # Format for display
    @subtotal_display = sprintf("$%.2f", @subtotal)
    @gst_display = sprintf("$%.2f", gst)
    @pst_display = sprintf("$%.2f", pst)
    @hst_display = sprintf("$%.2f", hst)
    @total_display = sprintf("$%.2f", @total)
    
    # Store the values in instance variables for the view
    @gst = gst
    @pst = pst
    @hst = hst
    @total = @subtotal + gst + pst + hst

    # Store tax values in instance variables for the view
    @province = province
    
    # Prepare cart items for display
    @cart_items = []
    cart.each do |product_id, quantity|
      product = Product.find(product_id)
      @cart_items << { product: product, quantity: quantity.to_i }
    end
    
    # Render the confirmation page
    render :confirm
  end

  def invoice
    if params[:session_id]
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
      session = Stripe::Checkout::Session.retrieve(params[:session_id])
      payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent)
      customer = Customer.find(session.metadata.customer_id)
      # Check if this is completing a previously created order
      existing_order = Order.find_by(id: session[:pending_order_id])
      
      if existing_order
        # Update the existing order
        existing_order.update(
          payment_id: payment_intent.id,
          status: "paid"
        )
        order = existing_order
        
        # Clear the pending order from session
        session.delete(:pending_order_id)
        session.delete(:pending_payment_intent_id)
      else
        # Create a new order
        order = Order.create!(
          customer: customer,
          total: payment_intent.amount_received / 100.0,
          gst: 0,
          pst: 0,
          hst: 0,
          payment_id: payment_intent.id,
          status: "paid"
        )
      end
      @order = order
      @customer = customer
      @subtotal = @order.total
      
      # Clear the cart after successful payment
      session[:cart] = {}
    else
      @order = Order.find(params[:id])
      @customer = @order.customer
      @subtotal = @order.total - (@order.gst + @order.pst + @order.hst)
    end
  end
  
  def latest_invoice
    # Find the most recent order for the current customer
    if customer_signed_in?
      @order = current_customer.orders.order(created_at: :desc).first
    else
      # For guests, try to find the order from the session
      @order = Order.find_by(id: session[:last_order_id])
    end
    
    if @order
      # Redirect to the actual invoice page
      redirect_to invoice_path(@order)
    else
      # If no order is found, redirect to the store with a message
      flash[:alert] = "No recent order found. Please try checking out again."
      redirect_to store_path
    end
  end

  def payment
    # Get the customer from the parameters or current user
    if customer_signed_in?
      @customer = current_customer
    else
      @customer = Customer.find_by(id: params[:customer_id])
      unless @customer
        flash[:alert] = "Customer information not found. Please try again."
        redirect_to checkout_path
        return
      end
    end
    
    amount = params[:amount].to_i
    begin
      # Create a PaymentIntent with automatic payment methods
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
      
      payment_intent = Stripe::PaymentIntent.create(
        amount: amount,
        currency: 'cad',
        automatic_payment_methods: { enabled: true }
      )
      # Check if this is completing a previously created order
      if session[:pending_order_id].present?
        # Update the existing order
        order = Order.find_by(id: session[:pending_order_id])
        if order
          order.update(
            payment_id: payment_intent.id,
            status: "paid"
          )
          # Clear the pending order from session
          session.delete(:pending_order_id)
          session.delete(:pending_payment_intent_id)
        else
          # If order not found, create a new one
          order = Order.create!(
            customer: @customer,
            total: amount / 100.0,
            gst: 0,
            pst: 0,
            hst: 0,
            payment_id: payment_intent.id,
            status: "paid"
          )
        end
      else
        # Create a new order with payment
        order = Order.create!(
          customer: @customer,
          total: amount / 100.0,
          gst: 0,
          pst: 0,
          hst: 0,
          payment_id: payment_intent.id,
          status: "paid"
        )
      end
      
      # Store the order ID in the session for guests
      session[:last_order_id] = order.id
      
      # Clear the cart
      session[:cart] = {}
      
      # Redirect user to invoice page or a success page
      redirect_to invoice_path(order), notice: "Payment successfully initiated!"
    rescue Stripe::StripeError => e
      flash[:alert] = "Stripe error: #{e.message}"
      redirect_to checkout_path
    end
  end

  def create
    # Get the customer from the parameters
    if customer_signed_in?
      @customer = current_customer
    else
      @customer = Customer.find_by(id: params[:customer_id]) || 
                 Customer.find_by(email: params[:customer][:email])
      
      # If we still can't find the customer, create a new one
      if @customer.nil?
        customer_data = params.require(:customer).permit(:name, :email, :address, :city, :province_id)
        customer_data[:name] = "Guest" if customer_data[:name].blank?
        customer_data[:email] = "guest_#{Time.now.to_i}@example.com" if customer_data[:email].blank?
        @customer = Customer.create!(customer_data)
      end
    end
    
    # Get the cart
    cart = session[:cart] || {}
    if cart.empty?
      flash[:alert] = "Your cart is empty. Please add items before checking out."
      redirect_to store_path
      return
    end
    
    # Calculate the subtotal
    subtotal = 0
    cart.each do |product_id, quantity|
      product = Product.find(product_id)
      subtotal += product.price * quantity.to_i
    end
    
    # Get the province for tax calculation
    province = Province.find(@customer.province_id)
    
    # Calculate taxes
    gst = subtotal * (province.gst || 0)
    pst = subtotal * (province.pst || 0)
    hst = subtotal * (province.hst || 0)
    
    # Calculate the total
    total = subtotal + gst + pst + hst
    
    # Initialize Stripe PaymentIntent
    if Stripe.api_key.blank?
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    end
    
    payment_intent = Stripe::PaymentIntent.create(
      amount: (total * 100).to_i, # Stripe expects amount in cents
      currency: 'cad',
      metadata: {
        customer_email: @customer.email
      }
    )
    
    # Determine if payment is immediate or deferred
    is_immediate_payment = params[:payment_method] == "immediate"
    
    # Create the order with appropriate status
    order = Order.create!(
      customer: @customer,
      total: total,
      gst: gst,
      pst: pst,
      hst: hst,
      payment_id: is_immediate_payment ? payment_intent.id : nil,
      status: is_immediate_payment ? "paid" : "processing"
    )
    
    # Store payment intent ID separately if not immediate payment
    unless is_immediate_payment
      # Store the payment intent ID in the session for later use
      session[:pending_payment_intent_id] = payment_intent.id
      session[:pending_order_id] = order.id
    end
    
    # Store the order ID in the session for guests
    session[:last_order_id] = order.id
    
    # Clear the cart
    session[:cart] = {}
    
    # Redirect to the invoice
    redirect_to invoice_path(order), notice: "Your order has been placed!"
  end

  private
  
  # Prevent caching of checkout pages
  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
  # Add a timestamp parameter to force browser to reload the page
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    
    # Add a timestamp to all asset URLs to force reload
    ENV["RAILS_ASSET_ID"] = DateTime.now.to_i.to_s
  end

  def customer_params
    # Get the basic customer parameters
    params_hash = params.require(:customer).permit(:name, :email, :address, :city, :province, :province_id)
    
    # Log what we received
    Rails.logger.debug "Raw customer params: #{params.require(:customer).inspect}"
    Rails.logger.debug "Permitted params: #{params_hash.inspect}"
    
    # Ensure province_id is an integer if present
    if params_hash[:province_id].present?
      params_hash[:province_id] = params_hash[:province_id].to_i
      Rails.logger.debug "Converted province_id to integer: #{params_hash[:province_id]}"
    end
    
    # Return the processed parameters
    params_hash
  end
end