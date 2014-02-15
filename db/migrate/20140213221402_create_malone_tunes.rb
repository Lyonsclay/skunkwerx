class CreateMaloneTunes < ActiveRecord::Migration
  def change
    create_table :malone_tunes do |t|

      t.timestamps
    end
  end
end
