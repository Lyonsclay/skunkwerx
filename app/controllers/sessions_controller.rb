# require 'pry'

class SessionsController < ApplicationController
  # layout can also receive symbol
  layout 'admin'

  def new

  end

  def create
# binding.pry
    email = params[:session][:email]
    password = params[:session][:password]
    admin = Admin.find_by(email: email)
    if admin && admin.authenticate(password)
      sign_in(admin)
# binding.pry

      redirect_to '/admin'
    else
      flash[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def delete
    sign_out
# binding.pry
    redirect_to '/admin'
  end
end
