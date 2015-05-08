class AddVehicleRefToMaloneTunes < ActiveRecord::Migration
  def change
    add_reference :malone_tunes, :vehicle, index: true
  end
end
