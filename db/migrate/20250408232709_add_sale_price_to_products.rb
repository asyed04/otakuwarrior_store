class AddSalePriceToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :sale_price, :decimal
  end
end
