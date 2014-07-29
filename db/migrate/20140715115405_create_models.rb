class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :model
      t.references :make, index: true

      t.timestamps
    end
  end
end
