class CreateMaloneTunings < ActiveRecord::Migration
  def change
    create_table :malone_tunings do |t|

      t.timestamps
    end
  end
end
