require "spec_helper"

describe AdminMailer do
  describe "password_reset" do
    let(:admin) { create(:admin, :password_reset_token => "nothing") }
    let(:mail) { AdminMailer.password_reset(admin) }

    it "sends admin password reset url" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([admin.email])
      mail.from.should eq(["clay.morton@gmail.com"])
      mail.body.encoded.should match(edit_password_reset_path(admin.password_reset_token))
    end
  end

end
