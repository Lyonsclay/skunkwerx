class CreateYears < ActiveRecord::Migration
  def change
    create_table :years do |t|
      t.string :years, array: true, default: '{}'
      t.string :range
      t.references :engine, index: true
    end
  end
end
