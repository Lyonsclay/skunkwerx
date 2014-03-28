require "spec_helper"

describe AdminMailer do
  describe "password_reset" do
    let(:admin) { create(:admin, :password_reset_token => "nothing") }
    let(:mail) { AdminMailer.password_reset(admin) }

    it "sends admin password reset url" do
      expect(mail.subject).to eq("Password Reset")
      expect(mail.to).to eq([admin.email])
      expect(mail.from).to eq([ENV['MAILER_USERNAME']])
      expect(mail.body.encoded).to match(edit_password_reset_path(admin.password_reset_token))
    end
  end

end
