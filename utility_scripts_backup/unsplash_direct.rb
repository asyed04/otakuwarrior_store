#!/usr/bin/env ruby
# This script updates product images using direct Unsplash URLs
# Run it with: rails runner unsplash_direct.rb

require 'open-uri'
require 'fileutils'

puts "Starting direct Unsplash image update process..."

# Create a temporary directory for downloaded images
temp_dir = Rails.root.join('tmp', 'unsplash_direct_images')
FileUtils.mkdir_p(temp_dir)

# Define direct Unsplash image URLs
unsplash_image_urls = [
  # Anime/Manga related images
  "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600",
  "https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600",
  "https://images.unsplash.com/photo-1613844237701-8f3664fc2eff?w=600",
  "https://images.unsplash.com/photo-1612033448550-9d6f9c17f07d?w=600",
  "https://images.unsplash.com/photo-1612033448483-3959e9f77b8e?w=600",
  "https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=600",
  "https://images.unsplash.com/photo-1605488686583-67dc0b9944ba?w=600",
  "https://images.unsplash.com/photo-1605487821865-8c6c9164a83f?w=600",
  "https://images.unsplash.com/photo-1541562232579-512a21360020?w=600",
  "https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?w=600",
  
  # Colorful images as fallbacks
  "https://images.unsplash.com/photo-1513151233558-d860c5398176?w=600",
  "https://images.unsplash.com/photo-1501084817091-a4f3d1d19e07?w=600",
  "https://images.unsplash.com/photo-1523821741446-edb2b68bb7a0?w=600",
  "https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600",
  "https://images.unsplash.com/photo-1527061011665-3652c757a4d4?w=600"
]

# Update each product with a direct Unsplash image URL
Product.find_each.with_index do |product, index|
  begin
    puts "Updating image for product #{product.id}: #{product.name}"
    
    # Use a different image for each product (cycling through the available images)
    image_url = unsplash_image_urls[index % unsplash_image_urls.length]
    puts "Using Unsplash image URL: #{image_url}"
    
    # Download the image to a temporary file
    temp_file_path = File.join(temp_dir, "product_#{product.id}.jpg")
    
    # Download the image
    begin
      IO.copy_stream(URI.open(image_url), temp_file_path)
      puts "Image downloaded successfully to: #{temp_file_path}"
    rescue => e
      puts "Error downloading image: #{e.message}"
      next
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

puts "✅ Finished direct Unsplash image update process"
puts "Please restart your Rails server and clear your browser cache to see the changes."