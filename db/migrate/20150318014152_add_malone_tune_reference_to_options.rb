class AddMaloneTuneReferenceToOptions < ActiveRecord::Migration
  def change
    add_reference :options, :malone_tune, index: true
  end
end
