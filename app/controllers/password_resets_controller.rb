require 'pry'

class PasswordResetsController < ApplicationController
  layout 'admin'

  def new
  end

  def create
    admin = Admin.find_by_email(params[:email])
    admin.send_password_reset if admin
    redirect_to login_url, :notice => "Email sent with password reset instructions."
  end

  def edit
# binding.pry
    @admin = find_admin
  end

  def update
    # On success redirect to admin home
# binding.pry
    admin = find_admin
    admin.update_attributes(password: params[:password], password_confirmation: params[:password_confirmation])
    if admin.save
      redirect_to admin
    else
      flash[:notice] = "You got problems"
      redirect_to(admin)
    end
  end
end