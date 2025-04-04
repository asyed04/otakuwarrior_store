class StoreController < ApplicationController
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
end
