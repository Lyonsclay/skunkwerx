class AddRememberTokenToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :remember_token, :string
  end
end
