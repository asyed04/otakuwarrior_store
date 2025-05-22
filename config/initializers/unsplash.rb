require 'unsplash'

# You'll need to register your application on the Unsplash Developer portal
# and replace these with your actual credentials
Unsplash.configure do |config|
  config.application_access_key = "YOUR_ACCESS_KEY"
  config.application_secret = "YOUR_SECRET_KEY"
  config.application_redirect_uri = "https://your-application.com/oauth/callback"
  config.utm_source = "otakuwarrior_store"
end