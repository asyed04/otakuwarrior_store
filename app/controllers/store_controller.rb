class StoreController < ApplicationController
  include Rails.application.routes.url_helpers

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

  def show
    @product = Product.find(params[:id])
  end

  def new_products
    @categories = Category.all
    @products = Product.new_products.includes(:category, image_attachment: :blob).page(params[:page]).per(6)
    render :index
  end

  def on_sale
    @categories = Category.all
    @products = Product.on_sale.includes(:category, image_attachment: :blob).page(params[:page]).per(6)
    render :index
  end
end
