#!/usr/bin/env ruby
# This script directly updates the database to ensure images are being updated
# Run it with: rails runner direct_db_update.rb

require 'open-uri'

puts "Starting direct database update for product images..."

# Get all active storage attachments for products
attachments = ActiveStorage::Attachment.where(record_type: 'Product')
puts "Found #{attachments.count} attachments for products"

# Delete all existing attachments
if attachments.any?
  puts "Deleting all existing attachments..."
  attachments.destroy_all
  puts "✅ All existing attachments deleted"
else
  puts "No existing attachments found"
end

# Get all active storage blobs
blobs = ActiveStorage::Blob.all
puts "Found #{blobs.count} blobs"

# Delete all existing blobs
if blobs.any?
  puts "Deleting all existing blobs..."
  blobs.destroy_all
  puts "✅ All existing blobs deleted"
else
  puts "No existing blobs found"
end

# Now create new attachments for each product
puts "Creating new attachments for each product..."

# Define direct image URLs
image_urls = [
  "https://i.imgur.com/dQw4w9W.jpg",
  "https://i.imgur.com/8kcsZAE.jpg",
  "https://i.imgur.com/JQFuREE.jpg",
  "https://i.imgur.com/pMFEsAM.jpg",
  "https://i.imgur.com/L9Vu0Jq.jpg"
]

Product.find_each.with_index do |product, index|
  begin
    puts "Creating new attachment for product #{product.id}: #{product.name}"
    
    # Use a different image for each product (cycling through the available images)
    image_url = image_urls[index % image_urls.length]
    puts "Using image URL: #{image_url}"
    
    # Download and attach the image
    file = URI.open(image_url)
    
    # Attach the new image with a unique filename to avoid caching
    timestamp = Time.now.to_i
    product.image.attach(io: file, filename: "product_#{product.id}_#{timestamp}.jpg", content_type: "image/jpeg")
    
    # Save the product to ensure changes are committed
    product.save!
    
    puts "✅ Successfully created new attachment for product #{product.id}"
    
    # Sleep briefly to avoid overwhelming the server
    sleep(0.5)
  rescue => e
    puts "❌ Error creating attachment for product #{product.id}: #{e.message}"
  end
end

puts "✅ Finished direct database update for product images"
puts "Please restart your Rails server and clear your browser cache to see the changes."