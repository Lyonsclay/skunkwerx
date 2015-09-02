class RemoveYearIdFromVehicles < ActiveRecord::Migration
  def change
    remove_column :vehicles, :year_id, :integer
  end
end
