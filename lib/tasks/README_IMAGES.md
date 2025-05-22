# Product Image Management

This document explains how to use the rake tasks for updating product images in the OtakuWarrior store.

## Available Tasks

### 1. Update All Product Images

This task will update all products in the database with relevant anime-themed images:

```bash
rails products:update_images
```

### 2. Update Images for a Specific Category

This task allows you to update images only for products in a specific category:

```bash
rails products:update_category_images[Figurines]
```

Replace `Figurines` with the name of the category you want to update.

## Using Unsplash API (Optional)

For better quality and more relevant images, you can configure the Unsplash API:

1. Register your application at https://unsplash.com/developers
2. Get your access key and secret
3. Update the configuration in `config/initializers/unsplash.rb`:

```ruby
Unsplash.configure do |config|
  config.application_access_key = "YOUR_ACCESS_KEY"  # Replace with your actual key
  config.application_secret = "YOUR_SECRET_KEY"      # Replace with your actual secret
  config.application_redirect_uri = "https://your-application.com/oauth/callback"
  config.utm_source = "otakuwarrior_store"
end
```

## Fallback Images

If the Unsplash API is not configured or encounters an error, the tasks will use a predefined set of anime-themed images from Unsplash.

## Notes

- The tasks include a 1-second delay between image updates to avoid rate limiting
- Existing images will be purged before attaching new ones to avoid duplicates
- Each category has specific search terms to find more relevant images