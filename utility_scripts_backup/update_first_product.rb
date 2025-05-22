#!/usr/bin/env ruby
# This script updates only the first product's image and verifies the update
# Run it with: rails runner update_first_product.rb

require 'open-uri'

puts "Updating the first product's image..."

# Get the first product
product = Product.first

if product.nil?
  puts "❌ No products found in the database"
  exit
end

puts "Found product: #{product.id} - #{product.name}"

# Check if the product has an image
if product.image.attached?
  blob = product.image.blob
  puts "Current image filename: #{blob.filename}"
  puts "Current image content type: #{blob.content_type}"
  puts "Current image created at: #{blob.created_at}"
  
  # Check if the file exists in storage
  file_path = Rails.root.join('storage', blob.key.first(2), blob.key.last(2), blob.key)
  if File.exist?(file_path)
    puts "Current file exists in storage: #{file_path}"
    puts "Current file size: #{File.size(file_path)} bytes"
    puts "Current file last modified: #{File.mtime(file_path)}"
  else
    puts "Current file does not exist in storage: #{file_path}"
  end
  
  # Remove the existing image
  puts "Removing existing image"
  product.image.purge
else
  puts "Product does not have an image attached"
end

# Use a direct image URL
image_url = "https://i.imgur.com/dQw4w9W.jpg"
puts "Using image URL: #{image_url}"

begin
  # Download and attach the image
  file = URI.open(image_url)
  
  # Attach the new image with a unique filename to avoid caching
  timestamp = Time.now.to_i
  product.image.attach(io: file, filename: "product_#{product.id}_#{timestamp}.jpg", content_type: "image/jpeg")
  
  # Save the product to ensure changes are committed
  product.save!
  
  puts "✅ Successfully updated image for product #{product.id}"
  
  # Verify the update
  if product.image.attached?
    new_blob = product.image.blob
    puts "New image filename: #{new_blob.filename}"
    puts "New image content type: #{new_blob.content_type}"
    puts "New image created at: #{new_blob.created_at}"
    
    # Check if the file exists in storage
    new_file_path = Rails.root.join('storage', new_blob.key.first(2), new_blob.key.last(2), new_blob.key)
    if File.exist?(new_file_path)
      puts "New file exists in storage: #{new_file_path}"
      puts "New file size: #{File.size(new_file_path)} bytes"
      puts "New file last modified: #{File.mtime(new_file_path)}"
    else
      puts "New file does not exist in storage: #{new_file_path}"
    end
  else
    puts "❌ Failed to attach new image"
  end
rescue => e
  puts "❌ Error updating image: #{e.message}"
end

puts "Update process complete."
puts "Please restart your Rails server and clear your browser cache to see the changes."