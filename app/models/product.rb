class Product < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[category created_at description id name price stock_quantity updated_at]
  end      

  def self.ransackable_associations(auth_object = nil)
    %w[image_attachment image_blob category]
  end

  has_one_attached :image
  belongs_to :category

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :image_presence

  # 🔽 Scopes for filtering
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }
  
  private
  
  def image_presence
    errors.add(:image, "must be attached") unless image.attached?
  end
end
