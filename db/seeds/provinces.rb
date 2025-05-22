# Create Canadian provinces with their tax rates
provinces = [
  { code: 'AB', name: 'Alberta', gst: 0.05, pst: 0.00, hst: 0.00 },
  { code: 'BC', name: 'British Columbia', gst: 0.05, pst: 0.07, hst: 0.00 },
  { code: 'MB', name: 'Manitoba', gst: 0.05, pst: 0.07, hst: 0.00 },
  { code: 'NB', name: 'New Brunswick', gst: 0.00, pst: 0.00, hst: 0.15 },
  { code: 'NL', name: 'Newfoundland and Labrador', gst: 0.00, pst: 0.00, hst: 0.15 },
  { code: 'NS', name: 'Nova Scotia', gst: 0.00, pst: 0.00, hst: 0.15 },
  { code: 'NT', name: 'Northwest Territories', gst: 0.05, pst: 0.00, hst: 0.00 },
  { code: 'NU', name: 'Nunavut', gst: 0.05, pst: 0.00, hst: 0.00 },
  { code: 'ON', name: 'Ontario', gst: 0.00, pst: 0.00, hst: 0.13 },
  { code: 'PE', name: 'Prince Edward Island', gst: 0.00, pst: 0.00, hst: 0.15 },
  { code: 'QC', name: 'Quebec', gst: 0.05, pst: 0.09975, hst: 0.00 },
  { code: 'SK', name: 'Saskatchewan', gst: 0.05, pst: 0.06, hst: 0.00 },
  { code: 'YT', name: 'Yukon', gst: 0.05, pst: 0.00, hst: 0.00 }
]

provinces.each do |province_data|
  province = Province.find_or_initialize_by(code: province_data[:code])
  province.update!(province_data)
  puts "Created or updated province: #{province.name}"
end