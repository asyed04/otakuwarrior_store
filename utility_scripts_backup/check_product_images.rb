#!/usr/bin/env ruby
# This script checks if products have images attached
# Run it with: rails runner check_product_images.rb

puts "Checking product images..."
puts "=========================="

total_products = Product.count
products_with_images = Product.joins(:image_attachment).distinct.count
products_without_images = total_products - products_with_images

puts "Total products: #{total_products}"
puts "Products with images: #{products_with_images}"
puts "Products without images: #{products_without_images}"
puts "=========================="

# Check a few specific products
puts "Checking specific products:"
puts "=========================="

# Check the first 5 products
Product.limit(5).each do |product|
  puts "Product ID: #{product.id}"
  puts "Product Name: #{product.name}"
  puts "Image attached: #{product.image.attached?}"
  
  if product.image.attached?
    puts "Image filename: #{product.image.filename}"
    puts "Image content type: #{product.image.content_type}"
    puts "Image URL: #{Rails.application.routes.url_helpers.rails_blob_path(product.image, only_path: true)}"
  end
  
  puts "=========================="
end

# Check if there are any issues with Active Storage
puts "Checking Active Storage configuration:"
puts "=========================="
puts "Active Storage service: #{Rails.application.config.active_storage.service}"
puts "=========================="