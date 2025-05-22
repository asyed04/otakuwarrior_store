#!/usr/bin/env ruby
# This script downloads Unsplash images to the public directory and updates products to use them
# Run it with: rails runner unsplash_public.rb

require 'open-uri'
require 'fileutils'

puts "Starting Unsplash public image update process..."

# Create a directory in public for the images
public_images_dir = Rails.root.join('public', 'product_images')
FileUtils.mkdir_p(public_images_dir)

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
  "https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?w=600"
]

# Download all images to the public directory
puts "Downloading images to public directory..."
unsplash_image_urls.each_with_index do |url, index|
  begin
    image_filename = "product_image_#{index + 1}.jpg"
    image_path = File.join(public_images_dir, image_filename)
    
    puts "Downloading image #{index + 1} to: #{image_path}"
    IO.copy_stream(URI.open(url), image_path)
    
    puts "✅ Successfully downloaded image #{index + 1}"
  rescue => e
    puts "❌ Error downloading image #{index + 1}: #{e.message}"
  end
  
  # Sleep briefly to avoid overwhelming the server
  sleep(1)
end

# Update each product to use the downloaded images
Product.find_each.with_index do |product, index|
  begin
    puts "Updating image for product #{product.id}: #{product.name}"
    
    # Use a different image for each product (cycling through the available images)
    image_filename = "product_image_#{(index % unsplash_image_urls.length) + 1}.jpg"
    image_path = File.join(public_images_dir, image_filename)
    
    # Check if the file exists
    if File.exist?(image_path)
      puts "Using public image: #{image_path}"
      
      # Force remove any existing image
      if product.image.attached?
        puts "Removing existing image"
        product.image.purge
      end
      
      # Attach the new image from the public file
      product.image.attach(io: File.open(image_path), filename: image_filename, content_type: "image/jpeg")
      
      # Save the product to ensure changes are committed
      product.save!
      
      puts "✅ Successfully updated image for product #{product.id}"
    else
      puts "❌ Public image not found: #{image_path}"
    end
  rescue => e
    puts "❌ Error updating image for product #{product.id}: #{e.message}"
  end
end

puts "✅ Finished Unsplash public image update process"
puts "Please restart your Rails server and clear your browser cache to see the changes."