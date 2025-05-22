#!/usr/bin/env ruby
# This script updates product images with anime-themed images
# Run it with: rails runner update_product_images.rb

require 'open-uri'

puts "Starting to update product images..."

# Define search terms based on categories
category_search_terms = {
  "Figurines" => ["anime figurine", "manga collectible", "anime statue"],
  "Apparel" => ["anime clothing", "manga t-shirt", "anime hoodie"],
  "Accessories" => ["anime accessory", "manga keychain", "anime bag"],
  "Home Decor" => ["anime poster", "manga wall art", "anime home decor"]
}

# Alternative image sources
anime_image_urls = [
  # Figurines
  "https://images.unsplash.com/photo-1608889825103-eb5ed706fc64?w=600",
  "https://images.unsplash.com/photo-1608889825205-eabe644039df?w=600",
  "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600",
  "https://images.unsplash.com/photo-1662457642839-5f2db1d59554?w=600",
  "https://images.unsplash.com/photo-1627672360124-4ed09583e14c?w=600",
  
  # Apparel
  "https://images.unsplash.com/photo-1584188832355-0c738fa0510a?w=600",
  "https://images.unsplash.com/photo-1584187839579-d9126b246d47?w=600",
  "https://images.unsplash.com/photo-1613844237701-8f3664fc2eff?w=600",
  "https://images.unsplash.com/photo-1612033448550-9d6f9c17f07d?w=600",
  "https://images.unsplash.com/photo-1612033448483-3959e9f77b8e?w=600",
  
  # Accessories
  "https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=600",
  "https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600",
  "https://images.unsplash.com/photo-1605488686583-67dc0b9944ba?w=600",
  "https://images.unsplash.com/photo-1605487821865-8c6c9164a83f?w=600",
  
  # Home Decor
  "https://images.unsplash.com/photo-1541562232579-512a21360020?w=600",
  "https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?w=600",
  "https://images.unsplash.com/photo-1618556450994-a6a128ef0d9d?w=600",
  "https://images.unsplash.com/photo-1618556450991-2f1af64e8191?w=600",
  "https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600",
  "https://images.unsplash.com/photo-1607082350899-7e105aa886ae?w=600"
]

# Update each product with a relevant image
Product.find_each.with_index do |product, index|
  begin
    puts "Updating image for product #{product.id}: #{product.name}"
    
    # Get search terms based on category
    category_name = product.category.name
    search_terms = category_search_terms[category_name] || ["anime", "manga"]
    
    # Use a random search term from the category's list
    search_term = search_terms.sample
    
    # Use a fallback image
    image_url = anime_image_urls[index % anime_image_urls.length]
    puts "Using image: #{image_url}"
    
    # Download and attach the image
    file = URI.open(image_url)
    # Remove any existing image to avoid duplicates
    product.image.purge if product.image.attached?
    product.image.attach(io: file, filename: "product_#{product.id}.jpg", content_type: "image/jpeg")
    
    puts "✅ Successfully updated image for product #{product.id}"
    
    # Sleep to avoid rate limiting
    sleep(1)
  rescue => e
    puts "❌ Error updating image for product #{product.id}: #{e.message}"
  end
end

puts "✅ Finished updating product images"