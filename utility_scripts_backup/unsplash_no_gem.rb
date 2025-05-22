#!/usr/bin/env ruby
# This script updates product images using Unsplash without requiring the Unsplash gem
# Run it with: rails runner unsplash_no_gem.rb

require 'open-uri'
require 'net/http'
require 'json'
require 'fileutils'

puts "Starting Unsplash image update process (no gem required)..."

# Create a temporary directory for downloaded images
temp_dir = Rails.root.join('tmp', 'unsplash_images')
FileUtils.mkdir_p(temp_dir)

# Define search terms for different categories
category_search_terms = {
  "Figurines" => ["anime figurine", "anime statue", "manga collectible"],
  "Apparel" => ["anime clothing", "anime tshirt", "manga hoodie"],
  "Accessories" => ["anime accessory", "anime keychain", "manga bag"],
  "Home Decor" => ["anime poster", "manga wallart", "anime decor"]
}

# Fallback direct image URLs in case the Unsplash API doesn't work
fallback_image_urls = [
  "https://images.unsplash.com/photo-1608889825103-eb5ed706fc64?w=600",
  "https://images.unsplash.com/photo-1608889825205-eabe644039df?w=600",
  "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600",
  "https://images.unsplash.com/photo-1662457642839-5f2db1d59554?w=600",
  "https://images.unsplash.com/photo-1627672360124-4ed09583e14c?w=600",
  "https://images.unsplash.com/photo-1584188832355-0c738fa0510a?w=600",
  "https://images.unsplash.com/photo-1584187839579-d9126b246d47?w=600",
  "https://images.unsplash.com/photo-1613844237701-8f3664fc2eff?w=600",
  "https://images.unsplash.com/photo-1612033448550-9d6f9c17f07d?w=600",
  "https://images.unsplash.com/photo-1612033448483-3959e9f77b8e?w=600"
]

# Function to get a random image URL from Unsplash
def get_unsplash_image_url(query)
  # Use the Unsplash public API (no authentication required for this endpoint)
  url = URI("https://source.unsplash.com/600x600/?#{URI.encode_www_form_component(query)}")
  
  # Make a request to get the redirected URL
  response = Net::HTTP.get_response(url)
  
  # Return the final URL after redirects
  if response.is_a?(Net::HTTPRedirection)
    return response['location']
  else
    return nil
  end
rescue => e
  puts "Error getting Unsplash image: #{e.message}"
  return nil
end

# Update each product with an Unsplash image
Product.find_each.with_index do |product, index|
  begin
    puts "Updating image for product #{product.id}: #{product.name}"
    
    # Get the category name
    category_name = product.category.name
    
    # Choose search terms based on category
    search_terms = category_search_terms[category_name] || ["anime", "manga"]
    search_term = search_terms.sample
    
    puts "Using search term: #{search_term}"
    
    # Try to get an image URL from Unsplash
    image_url = get_unsplash_image_url(search_term)
    
    # Use fallback if Unsplash API fails
    if image_url.nil?
      image_url = fallback_image_urls[index % fallback_image_urls.length]
      puts "Using fallback image URL: #{image_url}"
    else
      puts "Using Unsplash image URL: #{image_url}"
    end
    
    # Download the image to a temporary file
    temp_file_path = File.join(temp_dir, "product_#{product.id}.jpg")
    
    # Download the image
    begin
      IO.copy_stream(URI.open(image_url), temp_file_path)
      puts "Image downloaded successfully to: #{temp_file_path}"
    rescue => e
      puts "Error downloading image: #{e.message}"
      
      # Try fallback URL if download fails
      fallback_url = fallback_image_urls[index % fallback_image_urls.length]
      puts "Trying fallback URL: #{fallback_url}"
      IO.copy_stream(URI.open(fallback_url), temp_file_path)
    end
    
    # Check if the file was downloaded successfully
    if File.exist?(temp_file_path) && File.size(temp_file_path) > 0
      # Force remove any existing image
      if product.image.attached?
        puts "Removing existing image"
        product.image.purge
      end
      
      # Attach the new image from the temporary file
      product.image.attach(io: File.open(temp_file_path), filename: "product_#{product.id}.jpg", content_type: "image/jpeg")
      
      # Save the product to ensure changes are committed
      product.save!
      
      puts "✅ Successfully updated image for product #{product.id}"
    else
      puts "❌ Failed to download image to: #{temp_file_path}"
    end
    
    # Sleep briefly to avoid overwhelming the server
    sleep(1)
  rescue => e
    puts "❌ Error updating image for product #{product.id}: #{e.message}"
  end
end

# Clean up the temporary directory
FileUtils.rm_rf(temp_dir)

puts "✅ Finished Unsplash image update process"
puts "Please restart your Rails server and clear your browser cache to see the changes."