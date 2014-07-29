require 'rails_helper'

feature "AuthenticationPages" do
  feature "GET /login" do
   scenario "responds with 200" do
      visit login_path
      expect(page.current_path).to eq login_path
    end
  end

  subject { page }

  feature "Visit '/admin' with no session" do
    before { visit admin_path }
    scenario "redirects to login_path" do
      expect(current_path).to eq login_path
    end
  end

  feature "Sign in as admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { visit login_path(admin) }

    scenario { expect(self).to have_content('Log in') }
    scenario { expect(self).to have_title('Skunkwerx Admin Page') }
  end
end
