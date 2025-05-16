namespace :products do
  desc 'Update all products with relevant anime-themed images'
  task update_images: :environment do
    require 'open-uri'

    # Define search terms based on categories
    category_search_terms = {
      'Figurines' => ['anime figurine', 'manga collectible', 'anime statue'],
      'Apparel' => ['anime clothing', 'manga t-shirt', 'anime hoodie'],
      'Accessories' => ['anime accessory', 'manga keychain', 'anime bag'],
      'Home Decor' => ['anime poster', 'manga wall art', 'anime home decor'],
    }

    # Alternative image sources if Unsplash API is not set up
    anime_image_urls = [
      # Figurines
      'https://images.unsplash.com/photo-1608889825103-eb5ed706fc64?w=600',
      'https://images.unsplash.com/photo-1608889825205-eabe644039df?w=600',
      'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600',
      'https://images.unsplash.com/photo-1662457642839-5f2db1d59554?w=600',
      'https://images.unsplash.com/photo-1662457642839-5f2db1d59554?w=600',
      'https://images.unsplash.com/photo-1627672360124-4ed09583e14c?w=600',

      # Apparel
      'https://images.unsplash.com/photo-1584188832355-0c738fa0510a?w=600',
      'https://images.unsplash.com/photo-1584187839579-d9126b246d47?w=600',
      'https://images.unsplash.com/photo-1613844237701-8f3664fc2eff?w=600',
      'https://images.unsplash.com/photo-1612033448550-9d6f9c17f07d?w=600',
      'https://images.unsplash.com/photo-1612033448483-3959e9f77b8e?w=600',

      # Accessories
      'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=600',
      'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600',
      'https://images.unsplash.com/photo-1605488686583-67dc0b9944ba?w=600',
      'https://images.unsplash.com/photo-1605487821865-8c6c9164a83f?w=600',

      # Home Decor
      'https://images.unsplash.com/photo-1541562232579-512a21360020?w=600',
      'https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?w=600',
      'https://images.unsplash.com/photo-1618556450994-a6a128ef0d9d?w=600',
      'https://images.unsplash.com/photo-1618556450991-2f1af64e8191?w=600',
      'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600',
      'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?w=600',
    ]

    # Update each product with a relevant image
    Product.find_each.with_index do |product, index|
      puts "Updating image for product #{product.id}: #{product.name}"

      # Get search terms based on category
      category_name = product.category.name
      search_terms = category_search_terms[category_name] || %w[anime manga]

      # Use a random search term from the category's list
      search_term = search_terms.sample

      # Try to use Unsplash API if configured
      begin
        if defined?(Unsplash::Photo)
          # Check if Unsplash is properly configured
          if Unsplash.configuration.application_access_key == 'YOUR_ACCESS_KEY'
            # Unsplash not configured, use fallback
            image_url = anime_image_urls[index % anime_image_urls.length]
            puts "Unsplash not configured, using fallback image: #{image_url}"
          else
            photos = Unsplash::Photo.search(search_term, 1, 30)
            if photos.any?
              photo = photos.sample
              image_url = photo.urls.regular
              puts "Using Unsplash image: #{image_url}"
            else
              # Fallback to predefined URLs if no photos found
              image_url = anime_image_urls[index % anime_image_urls.length]
              puts "No Unsplash results, using fallback image: #{image_url}"
            end
          end
        else
          # Unsplash gem not available, use fallback
          image_url = anime_image_urls[index % anime_image_urls.length]
          puts "Unsplash gem not available, using fallback image: #{image_url}"
        end
      rescue StandardError => e
        # Any error with Unsplash, use fallback
        puts "Error with Unsplash: #{e.message}"
        image_url = anime_image_urls[index % anime_image_urls.length]
        puts "Using fallback image: #{image_url}"
      end

      # Download and attach the image
      file = URI.open(image_url)
      # Remove any existing image to avoid duplicates
      product.image.purge if product.image.attached?
      product.image.attach(io: file, filename: "product_#{product.id}.jpg", content_type: 'image/jpeg')

      puts "✅ Successfully updated image for product #{product.id}"

      # Sleep to avoid rate limiting
      sleep(1)
    rescue StandardError => e
      puts "❌ Error updating image for product #{product.id}: #{e.message}"
    end

    puts '✅ Finished updating product images'
  end

  desc 'Update images for products in a specific category'
  task :update_category_images, [:category_name] => :environment do |_t, args|
    require 'open-uri'

    category_name = args[:category_name]
    if category_name.blank?
      puts 'Please provide a category name. Example: rake products:update_category_images[Figurines]'
      exit
    end

    category = Category.find_by(name: category_name)
    if category.nil?
      puts "Category '#{category_name}' not found. Available categories: #{Category.pluck(:name).join(', ')}"
      exit
    end

    # Define search terms based on categories
    category_search_terms = {
      'Figurines' => ['anime figurine', 'manga collectible', 'anime statue'],
      'Apparel' => ['anime clothing', 'manga t-shirt', 'anime hoodie'],
      'Accessories' => ['anime accessory', 'manga keychain', 'anime bag'],
      'Home Decor' => ['anime poster', 'manga wall art', 'anime home decor'],
    }

    # Alternative image sources
    anime_image_urls = [
      # Figurines
      'https://images.unsplash.com/photo-1608889825103-eb5ed706fc64?w=600',
      'https://images.unsplash.com/photo-1608889825205-eabe644039df?w=600',
      'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600',
      'https://images.unsplash.com/photo-1662457642839-5f2db1d59554?w=600',
      'https://images.unsplash.com/photo-1662457642839-5f2db1d59554?w=600',
      'https://images.unsplash.com/photo-1627672360124-4ed09583e14c?w=600',

      # Apparel
      'https://images.unsplash.com/photo-1584188832355-0c738fa0510a?w=600',
      'https://images.unsplash.com/photo-1584187839579-d9126b246d47?w=600',
      'https://images.unsplash.com/photo-1613844237701-8f3664fc2eff?w=600',
      'https://images.unsplash.com/photo-1612033448550-9d6f9c17f07d?w=600',
      'https://images.unsplash.com/photo-1612033448483-3959e9f77b8e?w=600',

      # Accessories
      'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=600',
      'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600',
      'https://images.unsplash.com/photo-1605488686583-67dc0b9944ba?w=600',
      'https://images.unsplash.com/photo-1605487821865-8c6c9164a83f?w=600',

      # Home Decor
      'https://images.unsplash.com/photo-1541562232579-512a21360020?w=600',
      'https://images.unsplash.com/photo-1560419015-7c427e8ae5ba?w=600',
      'https://images.unsplash.com/photo-1618556450994-a6a128ef0d9d?w=600',
      'https://images.unsplash.com/photo-1618556450991-2f1af64e8191?w=600',
      'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600',
      'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?w=600',
    ]

    search_terms = category_search_terms[category_name] || %w[anime manga]

    puts "Updating images for products in category: #{category_name}"
    puts "Using search terms: #{search_terms.join(', ')}"

    category.products.find_each.with_index do |product, index|
      puts "Updating image for product #{product.id}: #{product.name}"

      # Use a random search term from the category's list
      search_term = search_terms.sample

      # Try to use Unsplash API if configured
      begin
        if defined?(Unsplash::Photo)
          # Check if Unsplash is properly configured
          if Unsplash.configuration.application_access_key == 'YOUR_ACCESS_KEY'
            # Unsplash not configured, use fallback
            image_url = anime_image_urls[index % anime_image_urls.length]
            puts "Unsplash not configured, using fallback image: #{image_url}"
          else
            photos = Unsplash::Photo.search(search_term, 1, 30)
            if photos.any?
              photo = photos.sample
              image_url = photo.urls.regular
              puts "Using Unsplash image: #{image_url}"
            else
              # Fallback to predefined URLs if no photos found
              image_url = anime_image_urls[index % anime_image_urls.length]
              puts "No Unsplash results, using fallback image: #{image_url}"
            end
          end
        else
          # Unsplash gem not available, use fallback
          image_url = anime_image_urls[index % anime_image_urls.length]
          puts "Unsplash gem not available, using fallback image: #{image_url}"
        end
      rescue StandardError => e
        # Any error with Unsplash, use fallback
        puts "Error with Unsplash: #{e.message}"
        image_url = anime_image_urls[index % anime_image_urls.length]
        puts "Using fallback image: #{image_url}"
      end

      # Download and attach the image
      file = URI.open(image_url)
      # Remove any existing image to avoid duplicates
      product.image.purge if product.image.attached?
      product.image.attach(io: file, filename: "product_#{product.id}.jpg", content_type: 'image/jpeg')

      puts "✅ Successfully updated image for product #{product.id}"

      # Sleep to avoid rate limiting
      sleep(1)
    rescue StandardError => e
      puts "❌ Error updating image for product #{product.id}: #{e.message}"
    end

    puts "✅ Finished updating images for products in category: #{category_name}"
  end
end
