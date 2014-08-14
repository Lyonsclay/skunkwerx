class AddDefaultValueToMaloneTune < ActiveRecord::Migration
  def up
    change_column_default :malone_tunes, :unit_cost, 0.0
  end

  def down
    change_column_default :malone_tunes, :unit_cost, nil
  end
end
