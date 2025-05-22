class AddProvinceReferenceToCustomers < ActiveRecord::Migration[7.1]
  def change
    # Add province_id as a foreign key
    add_reference :customers, :province, foreign_key: true
    
    # We'll keep the province string column temporarily for data migration
    # Later we can remove it with another migration after data is migrated
  end
end