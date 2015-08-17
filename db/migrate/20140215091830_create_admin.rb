class CreateAdmin < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :remember_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps
    end
  end
end
