require 'pry'

class AdminMailer < ActionMailer::Base
  default from: ENV['MAILER_USERNAME']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.password_reset.subject
  #
  def password_reset(admin)
    @admin = admin
    mail to: admin.email, subject: "Password Reset"
  end
end
