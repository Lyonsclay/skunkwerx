class RemoveColumnsFromMaloneTunes < ActiveRecord::Migration
  def change
    remove_column :malone_tunes, :year, :daterange
    remove_column :malone_tunes, :make, :hstore
    remove_column :malone_tunes, :model, :string
  end
end
