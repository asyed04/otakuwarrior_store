ActiveAdmin.register Product do
  include Rails.application.routes.url_helpers

  config.clear_action_items!  # optional, if you want to clear buttons like 'New Product'

  permit_params :name, :description, :price, :stock_quantity, :category_id, :image

  index do
    selectable_column
    column :name
    column :price
    column :stock_quantity
    column :category
    column "Image" do |product|
      if product.image.attached?
        image_tag url_for(product.image), size: "80x80"
      else
        "No Image"
      end
    end
    actions
  end

  filter :category

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :category
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image), size: "200x200"
        else
          "No Image Uploaded"
        end
      end
    end
  end
end
