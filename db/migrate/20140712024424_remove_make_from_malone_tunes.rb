class RemoveMakeFromMaloneTunes < ActiveRecord::Migration
  def change
    remove_column :malone_tunes, :make, :string
  end
end
