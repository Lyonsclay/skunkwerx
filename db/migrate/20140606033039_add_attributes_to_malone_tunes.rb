class AddAttributesToMaloneTunes < ActiveRecord::Migration
  def change
    add_column :malone_tunes, :engine, :string
    add_column :malone_tunes, :power, :string
    add_column :malone_tunes, :price_with_purchase, :decimal
    add_column :malone_tunes, :standalone_price, :decimal
  end
end
