#!/usr/bin/env ruby
# This script verifies if images are being updated in the database
# Run it with: rails runner verify_image_update.rb

puts "Verifying image updates in the database..."

# Get all products with attached images
products_with_images = Product.joins(:image_attachment).includes(image_attachment: :blob)

puts "Found #{products_with_images.count} products with attached images"

# Check each product's image
products_with_images.each do |product|
  puts "Product ID: #{product.id}"
  puts "Product Name: #{product.name}"
  
  # Get image details
  blob = product.image.blob
  puts "Image filename: #{blob.filename}"
  puts "Image content type: #{blob.content_type}"
  puts "Image created at: #{blob.created_at}"
  
  # Check if the file exists in storage
  file_path = Rails.root.join('storage', blob.key.first(2), blob.key.last(2), blob.key)
  if File.exist?(file_path)
    puts "File exists in storage: #{file_path}"
    puts "File size: #{File.size(file_path)} bytes"
    puts "File last modified: #{File.mtime(file_path)}"
  else
    puts "File does not exist in storage: #{file_path}"
  end
  
  puts "------------------------"
end

puts "Verification complete."