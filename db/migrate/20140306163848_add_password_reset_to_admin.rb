class AddPasswordResetToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :password_reset_token, :string
  end
end
