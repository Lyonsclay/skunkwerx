class RemoveForeignKeyOnVehicles < ActiveRecord::Migration
  def change
    remove_column(:vehicles, :year_id)
  end
end
