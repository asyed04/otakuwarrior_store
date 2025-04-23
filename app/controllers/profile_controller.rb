class ProfileController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_customer
  
  def show
    # Show customer profile
    @recent_orders = @customer.orders.recent.limit(5)
  end
  
  def edit
    # Edit customer profile
  end
  
  def update
    if @customer.update(customer_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def orders
    # Show all customer orders
    @orders = @customer.orders.recent.page(params[:page]).per(10)
  end
  
  def order
    # Show a specific order
    @order = @customer.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to profile_orders_path, alert: "Order not found."
  end
  
  def pay_order
    @order = @customer.orders.find(params[:id])
    
    if @order.paid?
      redirect_to profile_order_path(@order), alert: "This order has already been paid."
      return
    end
    
    # Initialize Stripe PaymentIntent
    if Stripe.api_key.blank?
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    end
    
    payment_intent = Stripe::PaymentIntent.create(
      amount: (@order.total * 100).to_i, # Stripe expects amount in cents
      currency: 'cad',
      metadata: {
        customer_email: @customer.email,
        order_id: @order.id
      }
    )
    
    # Update the order with the payment ID
    @order.update(payment_id: payment_intent.id, status: "paid")
    
    redirect_to profile_order_path(@order), notice: "Payment processed successfully!"
  rescue Stripe::StripeError => e
    redirect_to profile_order_path(@order), alert: "Payment error: #{e.message}"
  end
  
  private
  
  def set_customer
    @customer = current_customer
  end
  
  def customer_params
    params.require(:customer).permit(:name, :email, :address, :city, :province_id)
  end
end