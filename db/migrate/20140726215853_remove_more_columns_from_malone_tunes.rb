class RemoveMoreColumnsFromMaloneTunes < ActiveRecord::Migration
  def change
    remove_column :malone_tunes, :folder, :string
    remove_column :malone_tunes, :requires, :text
    remove_column :malone_tunes, :recommended, :text
    remove_column :malone_tunes, :engine, :string
    remove_column :malone_tunes, :power, :string
    remove_column :malone_tunes, :price_with_purchase, :decimal
    remove_column :malone_tunes, :standalone_price, :decimal
  end
end
