#!/usr/bin/env ruby
# This script updates a single product image for testing
# Run it with: rails runner update_single_product.rb PRODUCT_ID
# Example: rails runner update_single_product.rb 1

require 'open-uri'

product_id = ARGV[0] || 1
product = Product.find_by(id: product_id)

if product.nil?
  puts "❌ Product with ID #{product_id} not found"
  exit
end

puts "Updating image for product #{product.id}: #{product.name}"

# Choose a relevant image URL based on the product's category
anime_image_urls = {
  "Figurines" => [
    "https://images.unsplash.com/photo-1608889825103-eb5ed706fc64?w=600",
    "https://images.unsplash.com/photo-1608889825205-eabe644039df?w=600",
    "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600"
  ],
  "Apparel" => [
    "https://images.unsplash.com/photo-1584188832355-0c738fa0510a?w=600",
    "https://images.unsplash.com/photo-1584187839579-d9126b246d47?w=600",
    "https://images.unsplash.com/photo-1613844237701-8f3664fc2eff?w=600"
  ],
  "Accessories" => [
    "https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=600",
    "https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600",
    "https://images.unsplash.com/photo-1605488686583-67dc0b9944ba?w=600"
  ],
  "Home Decor" => [
    "https://images.unsplash.com/photo-1541562232579-512a21360020?w=600",
    "https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?w=600",
    "https://images.unsplash.com/photo-1618556450994-a6a128ef0d9d?w=600"
  ]
}

# Get the category name
category_name = product.category.name

# Choose a random image URL from the category's list, or use a default if category not found
image_urls = anime_image_urls[category_name] || [
  "https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600",
  "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600",
  "https://images.unsplash.com/photo-1584187839579-d9126b246d47?w=600"
]

image_url = image_urls.sample
puts "Using image URL: #{image_url}"

begin
  # Download and attach the image
  file = URI.open(image_url)
  
  # Remove any existing image to avoid duplicates
  product.image.purge if product.image.attached?
  
  # Attach the new image
  product.image.attach(io: file, filename: "product_#{product.id}.jpg", content_type: "image/jpeg")
  
  puts "✅ Successfully updated image for product #{product.id}"
rescue => e
  puts "❌ Error updating image: #{e.message}"
end