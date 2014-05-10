require 'spec_helper'
require 'capybara/rspec'

describe "AdminPages" do
  describe "GET /admin" do
    it "should redirect to login with no current session" do
      get admin_path
      expect(response).to redirect_to '/admin/login'
    end
  end
end

describe "Admin pages" do
  let(:admin) { FactoryGirl.create(:admin) }

  describe "invalid login" do
    before { visit login_path }
    it "should not redirect index" do
      click_button "Log in"
      expect(page).to have_text "Invalid email/password combination"
      expect(current_path).to eq(admin_sessions_path)
    end

    it "should redirect to index" do
      fill_in('Email', with: admin.email)
      fill_in('Password', with: admin.password)
      click_button "Log in"
      page.status_code.should be (200)
    end
  end
end