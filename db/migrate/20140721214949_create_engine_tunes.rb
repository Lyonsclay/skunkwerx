class CreateEngineTunes < ActiveRecord::Migration
  def change
    create_table :engine_tunes do |t|
      t.integer :malone_tune_id
      t.integer :engine_id

      t.timestamps
    end
  end
end
