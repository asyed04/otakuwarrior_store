class StoreController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    @products = Product.includes(:category, image_attachment: :blob).all
    @categories = Category.all
  end

  def category
    @categories = Category.all
    @category = Category.find(params[:id])
    @products = @category.products.includes(image_attachment: :blob)
    render :index
  end

  def show
    @product = Product.find(params[:id])
  end
  def new_products
    @categories = Category.all
    @products = Product.where('created_at >= ?', 3.days.ago)
    render :index
  end
  
  def on_sale
    @categories = Category.all
    @products = Product.where(on_sale: true)
    render :index
  end
  def on_sale
    @products = Product.on_sale.includes(:category, image_attachment: :blob)
    @categories = Category.all
    render :index
  end
  
  def new_products
    @products = Product.new_products.includes(:category, image_attachment: :blob)
    @categories = Category.all
    render :index
  end 
  def index
    @categories = Category.all
    @products = Product.includes(:category, image_attachment: :blob).page(params[:page]).per(6)
  end
  
  def category
    @categories = Category.all
    @category = Category.find(params[:id])
    @products = @category.products.includes(image_attachment: :blob).page(params[:page]).per(6)
    render :index
  end  
end
