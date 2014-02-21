class AddTimestampsToAdmin < ActiveRecord::Migration
  def change
    add_timestamps :admins do |t|
      t.timestamps
    end
  end
end
