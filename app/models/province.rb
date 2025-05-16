class Province < ApplicationRecord
  has_many :customers

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  # Helper method to get the tax rates as a hash
  def tax_rates
    {
      gst: gst,
      pst: pst,
      hst: hst,
    }
  end

  # Helper method to calculate taxes for a given amount
  def calculate_taxes(amount)
    {
      gst: (amount * gst).round(2),
      pst: (amount * pst).round(2),
      hst: (amount * hst).round(2),
    }
  end

  # Allow Ransack to search these fields
  def self.ransackable_attributes(_auth_object = nil)
    %w[code created_at gst hst id name pst updated_at]
  end
end
