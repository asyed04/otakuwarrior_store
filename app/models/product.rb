class Product < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
      %w[category created_at description id image_url name price stock_quantity updated_at]
    end
  end
  