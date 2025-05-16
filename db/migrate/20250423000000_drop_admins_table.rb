class DropAdminsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :admins if table_exists?(:admins)
  end

  def down
    # This migration is not reversible
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def table_exists?(table_name)
    ActiveRecord::Base.connection.table_exists?(table_name)
  end
end