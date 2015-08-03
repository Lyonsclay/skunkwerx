class RenameOptionsColumnMaloneTuneId < ActiveRecord::Migration
  def change
    rename_column :options, :malone_tune_id, :malone_tuning_id
  end
end
