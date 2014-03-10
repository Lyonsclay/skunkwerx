require 'spec_helper'

describe "PasswordResets" do
  let(:admin) { FactoryGirl.create(:admin) }
  it "emails user when requestiong password reset" do
    visit login_path
    click_link "password"
    fill_in "Email", :with => admin.email
    click_button "Send Email"
    current_path.should eq(login_path
      )
    page.should have_content("Email sent")
    last_email.to.should include(admin.email)
  end

  it "does not email invalid admin when requesting password reset" do
    visit login_path
    click_link "password"
    fill_in "Email", :with => "garbage"
    click_button "Send Email"
    current_path.should eq(login_path
      )
    page.should have_content("Email sent")
    last_email.should be_nil
  end

  it "updates the user password when confirmation matches" do
    visit edit_password_reset_path(admin.password_reset_token)
    fill_in "Password", :with => "foobar"
    fill_in "Password confirmation", :with => "foobar"
    click_button "Update Password"
    current_path.should eq(admin_path(admin))
    page.should have_content("Password has been reset")
  end
end