class RenameMaloneTuningsTableToMaloneTuningBuilders < ActiveRecord::Migration
  def change
    rename_table :malone_tunings, :malone_tuning_builders
  end
end
