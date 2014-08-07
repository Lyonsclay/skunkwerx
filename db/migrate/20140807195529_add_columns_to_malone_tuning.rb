class AddColumnsToMaloneTuning < ActiveRecord::Migration
  def change
    add_column :malone_tunings, :make, :string
    add_column :malone_tunings, :model, :string
  end
end
