require 'spec_helper'

describe "AuthenticationPages" do
  describe "GET /login" do
    it "responds with 200" do
      get login_path
      response.status.should be(200)
    end
  end

  subject { page }

  describe "Visit '/admin' with no session" do
    before { visit admin_path }
    it "redirects to login_path" do
      current_path.should eq login_path
    end
  end

  describe "Sign in as admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { visit login_path(admin) }

    it { should have_content('Log in') }
    it { should have_title('Skunkwerx Admin Page') }
  end
end
