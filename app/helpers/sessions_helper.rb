module SessionsHelper

  def sign_in(admin)
    remember_token = Admin.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    admin.update_attribute(:remember_token, Admin.encrypt(remember_token))
    self.current_admin = admin
  end

  def current_admin=(admin)
    @current_admin = admin
  end

  def sign_out
    flash[:notice] = "You have successfully signed out"
    cookies.permanent[:remember_token] = nil
    @current_admin = nil
  end

  def current_admin
    remember_token = Admin.encrypt(cookies[:remember_token])
    @current_admin ||= Admin.find_by(remember_token: remember_token)
  end

  def authorize
    unless current_admin
      redirect_to root_path
    end
  end
end
