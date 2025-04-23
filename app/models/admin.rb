class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
         
  # Define ransackable attributes for ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "remember_created_at", "reset_password_sent_at", "updated_at"]
  end
  
  # Define ransackable associations for ActiveAdmin
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
