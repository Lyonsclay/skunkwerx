class SessionsController < ApplicationController

  def new
  end

  def create
    email = params[:session][:email]
    password = params[:session][:password]
    admin = Admin.find_by(email: email)
    if admin && admin.authenticate(password)
      sign_in(admin)
      redirect_to '/admin'
    else
      flash[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def delete
    sign_out
    redirect_to '/admin'
  end
end
