class Order < ApplicationRecord
  belongs_to :customer

  # Define valid order statuses
  STATUSES = {
    processing: "processing",
    paid: "paid",
    shipped: "shipped",
    in_transit: "in_transit",
    out_for_delivery: "out_for_delivery",
    delivered: "delivered",
    cancelled: "cancelled"
  }

  # Validations
  validates :status, inclusion: { in: STATUSES.values }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :unpaid, -> { where(payment_id: nil) }
  scope :paid, -> { where.not(payment_id: nil) }
  
  # Status methods
  def paid?
    payment_id.present?
  end
  
  def can_pay?
    payment_id.blank?
  end
  
  def can_cancel?
    status != "cancelled" && status != "delivered"
  end
  
  def formatted_total
    "$#{sprintf('%.2f', total)}"
  end
  
  def formatted_date
    created_at.strftime("%B %d, %Y at %I:%M %p")
  end
  
  def status_badge_class
    case status
    when "processing"
      "bg-secondary"
    when "paid"
      "bg-success"
    when "shipped"
      "bg-info"
    when "in_transit"
      "bg-primary"
    when "out_for_delivery"
      "bg-warning"
    when "delivered"
      "bg-success"
    when "cancelled"
      "bg-danger"
    else
      "bg-secondary"
    end
  end

  # ✅ Allow Ransack to search customer association
  def self.ransackable_associations(auth_object = nil)
    ["customer"]
  end

  # ✅ Allow Ransack to search these fields in the Order table
  def self.ransackable_attributes(auth_object = nil)
    ["id", "customer_id", "gst", "pst", "hst", "total", "created_at", "updated_at", "payment_id", "status"]
  end
end
