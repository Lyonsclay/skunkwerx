class ChangeProductsAttributes < ActiveRecord::Migration
  def change
    change_column :products, :name, :text
    remove_column :products, :folder, :string
  end
end
