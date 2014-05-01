require 'pry'

class Admin::PasswordResetsController < ApplicationController
  layout 'admin/application'

  def new
  end

  def create
    admin = Admin.find_by_email(params[:email])
    if admin
      admin.send_password_reset
      redirect_to login_url, :notice => "Email sent with password reset instructions"
    else
      flash[:notice] = "Could not find that email address"
      redirect_to new_admin_passwords_reset_path
    end
  end

  def edit
# binding.pry
    @admin = find_admin
  end

  def update
    # On success redirect to admin home
# binding.pry
    admin = find_admin
# binding.pry
    password = params[:admin][:password]
    password_confirmation = params[:admin][:password_confirmation]
    admin.update_attributes(password: password, password_confirmation: password_confirmation)
    if admin.save
      flash[:notice] = "Password has been reset"
      redirect_to admin
    else
    flash[:notice] = admin.errors.messages
    redirect_to edit_admin_password_reset_path
    end
  end
end