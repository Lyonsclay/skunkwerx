class AddYearToVehicles < ActiveRecord::Migration
  def change
    add_reference :vehicles, :year, index: true
  end
end
