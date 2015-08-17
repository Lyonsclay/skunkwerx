class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name, limit: 50
      t.text :description
      t.integer :quantity
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :item_id
      t.decimal :unit_cost, precision: 8, scale: 2
      t.integer :inventory
      t.integer :tax1_id
      t.integer :tax2_id
      t.references :malone_tuning, index: true

      t.timestamps
    end
  end
end
