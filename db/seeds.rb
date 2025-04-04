# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
  end
  
  require 'faker'

  10.times do
    Product.create!(
      name: "#{Faker::Game.title} #{['Skin', 'Wrap', 'Mousepad', 'Keycap Set'].sample}",
      description: Faker::Games::Overwatch.quote, # or any other real-ish content
      price: rand(20..80),
      stock_quantity: rand(1..20),
      image_url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['gaming', 'anime']),
      category: ['Console Skin', 'Mousepad', 'Phone Case', 'Keycaps'].sample
    )
  end
  