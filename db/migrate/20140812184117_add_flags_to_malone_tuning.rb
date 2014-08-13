class AddFlagsToMaloneTuning < ActiveRecord::Migration
  def change
    add_column :malone_tunings, :tune_created, :boolean, default: false
    add_column :malone_tunings, :option_created, :boolean, default: false
  end
end
