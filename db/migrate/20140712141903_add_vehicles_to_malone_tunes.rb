class AddVehiclesToMaloneTunes < ActiveRecord::Migration
  def change
    add_column :malone_tunes, :vehicles, :hstore
  end
end
