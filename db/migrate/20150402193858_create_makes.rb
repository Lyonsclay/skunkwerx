class CreateMakes < ActiveRecord::Migration
  def change
    create_table :makes do |t|
      t.string :make
      t.references :vehicle, index: true
    end
  end
end
