class CartController < ApplicationController
    # Skip CSRF verification for debugging purposes
    # IMPORTANT: Remove this line after fixing the issue
    skip_before_action :verify_authenticity_token, only: [:add]
    
    # Add product to cart (increment quantity or initialize if new)
    def add
        session[:cart] = {} unless session[:cart].is_a?(Hash)
      
        product_id = params[:id].to_s
        session[:cart][product_id] = session[:cart].fetch(product_id, 0) + 1
      
        redirect_to cart_path, notice: "Product added to cart."
    end
      
  
    # Show cart contents
    def show
      @cart_items = []
  
      (session[:cart] || {}).each do |product_id, quantity|
        product = Product.find_by(id: product_id)
        if product
          @cart_items << { product: product, quantity: quantity }
        end
      end
    end
  
    # Remove product from cart
    def remove
      session[:cart]&.delete(params[:id].to_s)
      redirect_to cart_path, notice: "Product removed from cart."
    end
  
    # Update quantity of a product
    def update
        session[:cart] = {} unless session[:cart].is_a?(Hash)
      
        product_id = params[:id].to_s
        quantity = params[:quantity].to_i
      
        if quantity <= 0
          session[:cart].delete(product_id)
        else
          session[:cart][product_id] = quantity
        end
      
        redirect_to cart_path, notice: "Cart updated."
    end
      
  end
  