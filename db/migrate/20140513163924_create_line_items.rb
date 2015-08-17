class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :quantity, default: 1
      t.integer :item_id
      t.belongs_to :cart, index: true
      t.references :order, index: true

      t.timestamps
    end
  end
end
