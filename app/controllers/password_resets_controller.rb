class PasswordResetsController < ApplicationController

  def new
  end

  def create
    redirect_to root_url
  end

end