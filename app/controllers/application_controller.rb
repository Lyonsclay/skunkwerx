class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # By default helpers are available in views but not in controllers.
  include SessionsHelper
  include PasswordResetsHelper
  include Admin::FreshbooksHelper
end
