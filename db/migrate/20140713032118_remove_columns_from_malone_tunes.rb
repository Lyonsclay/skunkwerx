class RemoveColumnsFromMaloneTunes < ActiveRecord::Migration
  def change
    remove_column :malone_tunes, :year, :string
    remove_column :malone_tunes, :make, :string
    remove_column :malone_tunes, :model, :string
  end
end
