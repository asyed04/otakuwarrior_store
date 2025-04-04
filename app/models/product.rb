class Product < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        %w[category created_at description id name price stock_quantity updated_at]
    end      
    def self.ransackable_associations(auth_object = nil)
        %w[image_attachment image_blob]
    end
    has_one_attached :image
  end
  