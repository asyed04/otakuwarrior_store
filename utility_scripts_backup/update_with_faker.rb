#!/usr/bin/env ruby
# This script updates product images using Faker
# Run it with: rails runner update_with_faker.rb

require 'faker'
require 'open-uri'

puts "Starting to update product images with Faker..."

# Define search terms for Faker::LoremFlickr
category_search_terms = {
  "Figurines" => ["anime figurine", "anime statue", "manga collectible"],
  "Apparel" => ["anime clothing", "anime tshirt", "manga hoodie"],
  "Accessories" => ["anime accessory", "anime keychain", "manga bag"],
  "Home Decor" => ["anime poster", "manga wallart", "anime decor"]
}

# Update each product with a relevant image
Product.find_each do |product|
  begin
    puts "Updating image for product #{product.id}: #{product.name}"
    
    # Get search terms based on category
    category_name = product.category.name
    search_terms = category_search_terms[category_name] || ["anime", "manga"]
    
    # Use a random search term from the category's list
    search_term = search_terms.sample
    
    # Generate a Faker image URL
    image_url = Faker::LoremFlickr.image(size: "600x600", search_terms: [search_term])
    puts "Using Faker image URL: #{image_url}"
    
    # Download and attach the image
    file = URI.open(image_url)
    
    # Remove any existing image to avoid duplicates
    product.image.purge if product.image.attached?
    
    # Attach the new image
    product.image.attach(io: file, filename: "product_#{product.id}.jpg", content_type: "image/jpeg")
    
    puts "✅ Successfully updated image for product #{product.id}"
    
    # Sleep to avoid rate limiting
    sleep(1)
  rescue => e
    puts "❌ Error updating image for product #{product.id}: #{e.message}"
  end
end

puts "✅ Finished updating product images with Faker"