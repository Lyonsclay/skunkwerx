require 'spec_helper'

describe "AdminPages" do
  describe "GET /admin" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get admin_path
      response.should redirect_to login_path
    end
  end
end

describe "Admin pages" do

  subject { page }

  describe "invalid login" do
    before { visit login_path }
    it "should not redirect" do
      click_button "Log in"
      # response.status.should be(401)
    end
  end


  # describe "signup page" do
  #   before { visit login_path }

  #   it { should have_content('Sign up') }
  #   it { should have_title(full_title('Sign up')) }
  # end
end
