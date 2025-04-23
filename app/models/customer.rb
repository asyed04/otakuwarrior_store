class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :orders
  belongs_to :province, optional: true
  
  # Either province string or province_id must be present
  validate :province_information_present
  
  # Email validation is only required for registered users
  def email_required?
    encrypted_password.present?
  end
  
  def password_required?
    encrypted_password.present?
  end
  
  # Get province code - handles both old and new data structure
  def province_code
    if province_id.present?
      province.code
    else
      province
    end
  end
  
  private
  
  def province_information_present
    if province.blank? && province_id.blank?
      errors.add(:base, "Province information is required")
    end
  end
end