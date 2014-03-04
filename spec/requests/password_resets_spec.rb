# require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requestiong password reset" do
    admin = create(:admin)
    visit login_path
    click_link "password"
    fill_in "Email", :with => admin.email
    click_button "Send Email"
  end
end