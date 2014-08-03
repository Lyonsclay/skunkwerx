class ChangeColumnNameInMaloneTune < ActiveRecord::Migration
  def up
    MaloneTune.connection.execute("UPDATE malone_tunes SET name=LEFT(name,50)")
    change_column :malone_tunes, :name, :string, limit: 50
  end

  def down
    change_column :malone_tunes, :name, :string, limit: 255
  end
end