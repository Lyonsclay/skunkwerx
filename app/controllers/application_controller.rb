class ApplicationController < ActionController::Base
  include SessionsHelper
  include PasswordResetsHelper
  include Admin::FreshbooksHelper
  # include Admin::MaloneTuningBuildersHelper
  include LineItemsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
