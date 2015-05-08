class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.string :engine
      t.references :model, index: true
      t.references :vehicle, index: true
    end
  end
end
