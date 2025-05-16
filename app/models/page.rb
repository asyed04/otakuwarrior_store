class Page < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9-]+\z/, message: 'only allows lowercase letters, numbers, and hyphens' }

  # ✅ Add this method for Ransack to allow searching
  def self.ransackable_attributes(_auth_object = nil)
    %w[id title slug content created_at updated_at]
  end
end
