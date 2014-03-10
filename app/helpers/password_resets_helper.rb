require 'pry'

module PasswordResetsHelper
  def find_admin
    Admin.find_by_password_reset_token(params[:id])
  end
end