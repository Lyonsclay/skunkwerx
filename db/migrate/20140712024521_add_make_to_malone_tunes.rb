class AddMakeToMaloneTunes < ActiveRecord::Migration
  def change
    add_column :malone_tunes, :make, :hstore
  end
end
