require 'pry'

class AdminController < ApplicationController
  layout 'admin/application'
  def index
    if !current_admin
      redirect_to login_path
    # else
      # render "index"
    end
  end
end
