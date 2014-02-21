class AddNameAndPasswordDigestToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :name, :string
    add_column :admins, :password_digest, :string
  end
end
