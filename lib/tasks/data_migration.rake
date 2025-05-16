namespace :data do
  desc 'Migrate province string to province_id for existing customers'
  task migrate_provinces: :environment do
    puts 'Starting province migration for customers...'

    # Make sure provinces are loaded
    if Province.count.zero?
      puts 'No provinces found. Loading provinces first...'
      load Rails.root.join('db', 'seeds', 'provinces.rb')
    end

    # Get all customers with province string but no province_id
    customers = Customer.where.not(province: [nil, '']).where(province_id: nil)

    puts "Found #{customers.count} customers to migrate"

    migrated = 0
    skipped = 0

    customers.find_each do |customer|
      province = Province.find_by(code: customer.province)

      if province
        customer.update_column(:province_id, province.id)
        migrated += 1
        puts "Migrated customer ##{customer.id} from province '#{customer.province}' to province_id #{province.id}"
      else
        skipped += 1
        puts "Could not find province for customer ##{customer.id} with province '#{customer.province}'"
      end
    end

    puts 'Migration complete!'
    puts "Migrated: #{migrated}"
    puts "Skipped: #{skipped}"
  end
end
