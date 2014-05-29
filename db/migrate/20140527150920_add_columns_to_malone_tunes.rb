class AddColumnsToMaloneTunes < ActiveRecord::Migration
  def change
    add_column :malone_tunes, :requires, :text
    add_column :malone_tunes, :recommended, :text
    add_column :malone_tunes, :year, :string
    add_column :malone_tunes, :make, :string
    add_column :malone_tunes, :model, :string
  end
end
