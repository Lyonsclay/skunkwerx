require 'spec_helper'
require 'capybara/rspec'
require 'pry'

describe "Freshbooks webhook request" do
  describe "Get callback_item_create" do
    it "has response success" do
    post admin_callback_item_create_path
    expect(response.status).to eq(200)
    end

    it "makes a call to Freshbooks api" do
      # SessionsHelper.stub(:current_admin).and_return(true)
      admin = FactoryGirl.create(:admin)
      post_via_redirect sessions_path, session: { email: admin.email, password: admin.password }
      post admin_callback_item_create_path
      expect(response.status).to eq(200)
      expect(session[:callback_id]).to_not eq(nil)
# binding.pry
    # action: callback_verify, controller: admin/freshbooks
      # name=callback.verify&object_id=1&system=https%3A%2F%2F2ndsite.freshbooks.com&user_id=1&verifier=3bPTNcPgbN76QLgKLSR9XdgQJWvhhN4xrT
      post callback_verify_path, name: "callback.verify", verifier: "3bPTNcPgbN76QLgKLSR9XdgQJWvhhN4xrT"
    end
  end
end