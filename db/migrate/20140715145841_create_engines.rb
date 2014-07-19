class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.string :engine
      t.string :years, array: true
      t.references :model, index: true

      t.timestamps
    end
  end
end
