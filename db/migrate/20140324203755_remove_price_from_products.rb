class RemovePriceFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :price, :decimal
  end

  def self.down
    add_column :products, :price, :decimal
  end
end
