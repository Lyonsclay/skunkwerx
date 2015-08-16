require 'rails_helper'

feature "AdminPages" do
  feature "GET /admin" do
    scenario "should redirect to login with no current session" do
      visit admin_path
      expect(status_code).to eq 200
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
      expect(status_code).to eq 200
    end
  end
end
