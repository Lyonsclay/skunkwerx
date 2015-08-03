class RenameMaloneTunesTableToMaloneTunings < ActiveRecord::Migration
  def change
    rename_table :malone_tunes, :malone_tunings
  end
end
