#!/usr/bin/env ruby
# This script creates the necessary static pages in the database

# Privacy Policy page
privacy_page = Page.find_or_initialize_by(slug: "privacy")
privacy_page.title = "Privacy Policy"
privacy_page.content = "<h1>Privacy Policy</h1><p>This is the privacy policy content.</p>"
privacy_page.save!
puts "Created Privacy Policy page"

# Terms of Service page
terms_page = Page.find_or_initialize_by(slug: "terms")
terms_page.title = "Terms of Service"
terms_page.content = "<h1>Terms of Service</h1><p>This is the terms of service content.</p>"
terms_page.save!
puts "Created Terms of Service page"

puts "All pages created successfully!"