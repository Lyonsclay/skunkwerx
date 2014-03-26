class AddUpdatedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :updated, :string
  end
end
