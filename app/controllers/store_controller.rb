class StoreController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    @categories = Category.all
    @products = Product.includes(:category, image_attachment: :blob).page(params[:page]).per(6)
    @page_title = "All Products"
  end

  def category
    @categories = Category.all
    @category = Category.find(params[:id])
    @products = @category.products.includes(image_attachment: :blob).page(params[:page]).per(6)
    @page_title = "#{@category.name} Products"
    render :index
  end

  def show
    @product = Product.find(params[:id])
  end

  def new_products
    @categories = Category.all
    @products = Product.new_products.includes(:category, image_attachment: :blob).page(params[:page]).per(6)
    @page_title = "New Products"
    render :index
  end

  def on_sale
    @categories = Category.all
    @products = Product.on_sale.includes(:category, image_attachment: :blob).page(params[:page]).per(6)
    @page_title = "On Sale Products"
    render :index
  end

  def search
    @categories = Category.all
    @products = Product.includes(:category, image_attachment: :blob)

    if params[:query].present?
      query = "%#{params[:query].downcase}%"
      @products = @products.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", query, query)
    end

    if params[:category_id].present? && params[:category_id] != ""
      @products = @products.where(category_id: params[:category_id])
    end

    @products = @products.page(params[:page]).per(6)
    @page_title = "Search Results"
    render :index
  end
end
