class CreateMaloneTuningBuilders < ActiveRecord::Migration
  def change
    create_table :malone_tuning_builders do |t|
      t.text :name
      t.string :engine
      t.string :power
      t.string :graph_url
      t.text :description
      t.string :unit_cost
      t.string :standalone_price
      t.string :price_with_purchase
      t.string :requires_urls, array: true, default: '{}'
      t.string :recommended_urls, array: true, default: '{}'

      t.timestamps
    end
  end
end
