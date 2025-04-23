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
  
  def cancel_order
    @order = @customer.orders.find(params[:id])
    
    # Check if the order can be cancelled
    if @order.status == "cancelled"
      redirect_to profile_order_path(@order), alert: "This order has already been cancelled."
      return
    end
    
    # Don't allow cancellation of delivered orders
    if @order.status == "delivered"
      redirect_to profile_order_path(@order), alert: "Cannot cancel an order that has been delivered."
      return
    end
    
    # If the order was paid, we should handle refund logic here
    # This is a simplified version - in a real application, you would integrate with
    # your payment processor (like Stripe) to issue refunds
    if @order.paid? && @order.payment_id.present?
      begin
        # Initialize Stripe if needed
        if Stripe.api_key.blank?
          Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
        end
        
        # Create a refund for the payment
        Stripe::Refund.create({
          payment_intent: @order.payment_id,
          reason: 'requested_by_customer'
        })
      rescue Stripe::StripeError => e
        # Log the error but still cancel the order
        Rails.logger.error "Refund error for order ##{@order.id}: #{e.message}"
        # You might want to notify an admin about the failed refund
      end
    end
    
    # Update the order status to cancelled
    @order.update(status: "cancelled")
    
    redirect_to profile_order_path(@order), notice: "Order has been cancelled successfully."
  end
  
  private
  
  def set_customer
    @customer = current_customer
  end
  
  def customer_params
    params.require(:customer).permit(:name, :email, :address, :city, :province_id)
  end
end