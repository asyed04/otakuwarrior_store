class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.decimal :gst, precision: 5, scale: 3, default: 0
      t.decimal :pst, precision: 5, scale: 3, default: 0
      t.decimal :hst, precision: 5, scale: 3, default: 0

      t.timestamps
    end
    
    add_index :provinces, :code, unique: true
  end
end