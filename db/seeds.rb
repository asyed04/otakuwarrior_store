require 'csv'
require 'faker'
require 'open-uri'

# Admin setup
Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end

# Load categories from CSV
categories = {}
CSV.foreach(Rails.root.join('db', 'categories.csv'), headers: true) do |row|
  name = row['name']
  category = Category.find_or_create_by!(name: name)
  categories[category.name] = category
end

# Product setup (25 per category)
require 'faker'
require 'open-uri'

categories.each do |name, category|
  25.times do
    on_sale = [true, false].sample
    product = Product.create!(
      name: "#{Faker::Game.title} #{['Skin', 'Wrap', 'Mousepad', 'Keycap Set'].sample}",
      description: Faker::Games::Overwatch.quote,
      price: rand(20..80),
      stock_quantity: rand(5..30),
      category: category,
      on_sale: on_sale,
      sale_price: on_sale ? rand(10..70) : nil
    )

    image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: ['gaming', 'anime'])
    file = URI.open(image_url)
    product.image.attach(io: file, filename: "product_#{product.id}.jpg", content_type: "image/jpg")
  end
end
# --- Static Pages ---
Page.find_or_create_by!(slug: "about") do |page|
  page.title = "About Us"
  page.content = "This is the about page content."
end

Page.find_or_create_by!(slug: "contact") do |page|
  page.title = "Contact Us"
  page.content = "This is the contact page content."
end

Page.find_or_create_by!(slug: "privacy") do |page|
  page.title = "Privacy Policy"
  page.content = "This is the privacy policy content."
end

Page.find_or_create_by!(slug: "terms") do |page|
  page.title = "Terms of Service"
  page.content = "This is the terms of service content."
end


# Load provinces data
load Rails.root.join('db', 'seeds', 'provinces.rb')

puts "✅ Seeded 100 products (25 per category) and provinces"

# --- Seed Canadian Provinces with GST/PST/HST rates ---
provinces_data = [
  { name: "MB", gst: 0.05, pst: 0.07, hst: 0.0 },
  { name: "ON", gst: 0.0, pst: 0.0, hst: 0.13 },
  { name: "QC", gst: 0.05, pst: 0.09975, hst: 0.0 },
  { name: "BC", gst: 0.05, pst: 0.07, hst: 0.0 },
  { name: "AB", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "NS", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "NB", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "SK", gst: 0.05, pst: 0.06, hst: 0.0 },
  { name: "NL", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "PE", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "NT", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "NU", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "YT", gst: 0.05, pst: 0.0, hst: 0.0 }
]

provinces_data.each do |prov|
  Province.find_or_create_by!(name: prov[:name]) do |p|
    p.gst = prov[:gst]
    p.pst = prov[:pst]
    p.hst = prov[:hst]
  end
end

puts "✅ Provinces seeded successfully!"

