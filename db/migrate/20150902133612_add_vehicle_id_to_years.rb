class AddVehicleIdToYears < ActiveRecord::Migration
  def change
    add_column :years, :vehicle_id, :integer
    add_index :years, :vehicle_id
  end
end
