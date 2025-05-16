#!/usr/bin/env ruby
# This script updates product images with direct URLs - no gems required
# Run it with: rails runner simple_image_update.rb

require 'open-uri'

puts "Starting simple image update process..."

# Define direct image URLs that don't require any gems
image_urls = [
  "https://i.imgur.com/dQw4w9W.jpg",
  "https://i.imgur.com/8kcsZAE.jpg",
  "https://i.imgur.com/JQFuREE.jpg",
  "https://i.imgur.com/pMFEsAM.jpg",
  "https://i.imgur.com/L9Vu0Jq.jpg",
  "https://i.imgur.com/YWGKblF.jpg",
  "https://i.imgur.com/qVxaFUt.jpg",
  "https://i.imgur.com/2Yd2Oo3.jpg",
  "https://i.imgur.com/JKgQAq1.jpg",
  "https://i.imgur.com/8Yx3XTu.jpg"
]

# Update each product with a direct image URL
Product.find_each.with_index do |product, index|
  begin
    puts "Updating image for product #{product.id}: #{product.name}"
    
    # Use a different image for each product (cycling through the available images)
    image_url = image_urls[index % image_urls.length]
    puts "Using image URL: #{image_url}"
    
    # Download and attach the image
    file = URI.open(image_url)
    
    # Force remove any existing image
    if product.image.attached?
      puts "Removing existing image"
      product.image.purge
    end
    
    # Attach the new image with a unique filename to avoid caching
    timestamp = Time.now.to_i
    product.image.attach(io: file, filename: "product_#{product.id}_#{timestamp}.jpg", content_type: "image/jpeg")
    
    # Save the product to ensure changes are committed
    product.save!
    
    puts "✅ Successfully updated image for product #{product.id}"
    
    # Sleep briefly to avoid overwhelming the server
    sleep(0.5)
  rescue => e
    puts "❌ Error updating image for product #{product.id}: #{e.message}"
  end
end

puts "✅ Finished simple image update process"
puts "Please restart your Rails server and clear your browser cache to see the changes."