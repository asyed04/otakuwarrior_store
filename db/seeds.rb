# Admin setup
Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
  end
  
  # Category setup
  category_names = ['Console Skin', 'Mousepad', 'Phone Case', 'Keycaps']
  categories = {}
  
  category_names.each do |name|
    categories[name] = Category.find_or_create_by!(name: name)
  end
  
  # Product setup
  require 'faker'
  require 'open-uri'
  
  10.times do
    category_name = category_names.sample
    product = Product.create!(
      name: "#{Faker::Game.title} #{['Skin', 'Wrap', 'Mousepad', 'Keycap Set'].sample}",
      description: Faker::Games::Overwatch.quote,
      price: rand(20..80),
      stock_quantity: rand(1..20),
      category: categories[category_name]
    )
  
    # Attach a placeholder image
    image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: ['gaming', 'anime'])
    file = URI.open(image_url)
    product.image.attach(io: file, filename: "product_#{product.id}.jpg", content_type: "image/jpg")
  end
  