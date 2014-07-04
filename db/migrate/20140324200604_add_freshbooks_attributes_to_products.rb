class AddFreshbooksAttributesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :item_id, :integer
    add_column :products, :unit_cost, :decimal, precision: 8, scale: 2
    add_column :products, :inventory, :integer
    add_column :products, :folder, :string
    add_column :products, :tax1_id, :integer
    add_column :products, :tax2_id, :integer
  end
end
