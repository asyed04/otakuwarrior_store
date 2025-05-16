#!/usr/bin/env ruby
# This script tests updating a single product image with a direct URL
# Run it with: rails runner test_single_image.rb

require 'open-uri'

puts "Testing image update for a single product..."

# Find the first product
product = Product.first

if product.nil?
  puts "❌ No products found in the database"
  exit
end

puts "Found product: #{product.id} - #{product.name}"

# Use a direct image URL that's definitely different from what's currently attached
test_image_url = "https://i.imgur.com/dQw4w9W.jpg" # This is a recognizable image

puts "Using test image URL: #{test_image_url}"

begin
  # Download and attach the image
  file = URI.open(test_image_url)
  
  # Force remove any existing image
  if product.image.attached?
    puts "Removing existing image: #{product.image.filename}"
    product.image.purge
  end
  
  # Attach the new image with a unique filename to avoid caching
  timestamp = Time.now.to_i
  product.image.attach(io: file, filename: "test_image_#{timestamp}.jpg", content_type: "image/jpeg")
  
  # Save the product to ensure changes are committed
  product.save!
  
  puts "✅ Successfully updated image for product #{product.id}"
  puts "Please check the product page to see if the image has changed"
  puts "If you still see the old image, try clearing your browser cache or opening in an incognito window"
rescue => e
  puts "❌ Error updating image: #{e.message}"
end