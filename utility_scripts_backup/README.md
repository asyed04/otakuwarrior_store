# Otaku Warrior Store Utility Scripts

This directory contains utility scripts that were used for setting up and maintaining the Otaku Warrior Store application. These scripts have been moved here to clean up the root directory.

## Image Management Scripts

- `check_product_images.rb` - Checks if products have images attached
- `clear_and_regenerate_images.rb` - Clears existing product images and regenerates them
- `force_update_images.rb` - Forces update of product images
- `simple_image_update.rb` - Simple script to update product images
- `test_single_image.rb` - Tests image upload for a single product
- `update_first_product.rb` - Updates the image for the first product
- `update_product_images.rb` - Updates all product images with anime-themed images from Unsplash
- `update_single_product.rb` - Updates a single product's image
- `verify_image_update.rb` - Verifies that product images were updated correctly

## Unsplash Integration Scripts

- `unsplash_direct.rb` - Directly fetches images from Unsplash
- `unsplash_no_gem.rb` - Fetches images from Unsplash without using the gem
- `unsplash_public.rb` - Fetches public images from Unsplash

## Google Cloud Storage Scripts

- `create_bucket.rb` - Creates a Google Cloud Storage bucket for storing images
- `create_bucket.js` - JavaScript version of the bucket creation script
- `test_gcs_connection.js` - Tests connection to Google Cloud Storage

## Data Management Scripts

- `create_pages.rb` - Creates static pages for the store
- `direct_db_update.rb` - Directly updates the database
- `update_with_faker.rb` - Updates product data using Faker gem

These scripts were used for one-time setup tasks and are not part of the core application. They have been moved here to clean up the root directory but are preserved in case they are needed again in the future.