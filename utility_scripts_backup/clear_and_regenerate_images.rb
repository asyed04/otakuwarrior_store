#!/usr/bin/env ruby
# This script completely clears all product images and regenerates them
# Run it with: rails runner clear_and_regenerate_images.rb

require 'open-uri'

puts "Starting complete image regeneration process..."

# Define direct image URLs for each category
direct_image_urls = {
  "Figurines" => [
    "https://i.imgur.com/8kcsZAE.jpg", # Anime figurine 1
    "https://i.imgur.com/JQFuREE.jpg", # Anime figurine 2
    "https://i.imgur.com/pMFEsAM.jpg", # Anime figurine 3
    "https://i.imgur.com/L9Vu0Jq.jpg", # Anime figurine 4
    "https://i.imgur.com/YWGKblF.jpg"  # Anime figurine 5
  ],
  "Apparel" => [
    "https://i.imgur.com/qVxaFUt.jpg", # Anime shirt 1
    "https://i.imgur.com/2Yd2Oo3.jpg", # Anime shirt 2
    "https://i.imgur.com/JKgQAq1.jpg", # Anime hoodie
    "https://i.imgur.com/8Yx3XTu.jpg", # Anime jacket
    "https://i.imgur.com/5Ub9Ecd.jpg"  # Anime costume
  ],
  "Accessories" => [
    "https://i.imgur.com/CtaXiF7.jpg", # Anime keychain
    "https://i.imgur.com/Hl2NhH5.jpg", # Anime bag
    "https://i.imgur.com/YWwAJIY.jpg", # Anime wallet
    "https://i.imgur.com/8kPi9gQ.jpg", # Anime phone case
    "https://i.imgur.com/L2XgUDc.jpg"  # Anime hat
  ],
  "Home Decor" => [
    "https://i.imgur.com/pVOzjOV.jpg", # Anime poster
    "https://i.imgur.com/QMdcMwk.jpg", # Anime wall scroll
    "https://i.imgur.com/8Yx3XTu.jpg", # Anime lamp
    "https://i.imgur.com/L9Vu0Jq.jpg", # Anime pillow
    "https://i.imgur.com/YWGKblF.jpg"  # Anime blanket
  ]
}

# Default images if category not found
default_images = [
  "https://i.imgur.com/8kcsZAE.jpg",
  "https://i.imgur.com/JQFuREE.jpg",
  "https://i.imgur.com/pMFEsAM.jpg",
  "https://i.imgur.com/L9Vu0Jq.jpg",
  "https://i.imgur.com/YWGKblF.jpg"
]

# Step 1: Purge all existing product images
puts "Step 1: Purging all existing product images..."
Product.find_each do |product|
  if product.image.attached?
    puts "Purging image for product #{product.id}: #{product.name}"
    product.image.purge
  end
end

# Step 2: Regenerate all product images
puts "Step 2: Regenerating all product images..."
Product.find_each.with_index do |product, index|
  begin
    puts "Regenerating image for product #{product.id}: #{product.name}"
    
    # Get the category name
    category_name = product.category.name
    
    # Choose image URLs based on category
    image_urls = direct_image_urls[category_name] || default_images
    
    # Use a different image for each product (cycling through the available images)
    image_url = image_urls[index % image_urls.length]
    puts "Using direct image URL: #{image_url}"
    
    # Download and attach the image
    file = URI.open(image_url)
    
    # Attach the new image with a unique filename to avoid caching
    timestamp = Time.now.to_i
    product.image.attach(io: file, filename: "product_#{product.id}_#{timestamp}.jpg", content_type: "image/jpeg")
    
    # Save the product to ensure changes are committed
    product.save!
    
    puts "✅ Successfully regenerated image for product #{product.id}"
    
    # Sleep briefly to avoid overwhelming the server
    sleep(0.5)
  rescue => e
    puts "❌ Error regenerating image for product #{product.id}: #{e.message}"
  end
end

puts "✅ Finished complete image regeneration process"
puts "Please restart your Rails server and clear your browser cache to see the changes."