class AddStatusToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :status, :string, default: "processing"
    add_index :orders, :status
  end
end