class AdminController < ApplicationController

  def index
    if !current_admin
      # redirect_to login_path
    # else
      render "index"
    end
  end
end
