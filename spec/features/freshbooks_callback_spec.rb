require 'spec_helper'
require 'capybara/rspec'
require 'pry'

describe "Freshbooks webhook request" do
  describe "Post webhook_create" do
    it "has response success" do
    post admin_webhook_create_path
    expect(response.status).to eq(302)
    end

    it "makes a call to Freshbooks api" do
      # include Admin::FreshbooksHelper
      admin = FactoryGirl.create(:admin)
      SessionsHelper.stub(:current_admin).and_return(admin)
      # post_via_redirect sessions_path, session: { email: admin.email, password: admin.password }
      # This method calls actual Freshbooks api
      post admin_webhook_create_path, method: "item.create"
      expect(response.status).to eq(302) # redirect_to '/admin'
      expect(Rails.cache.read "callback_id").to_not eq(nil)
# binding.pry
      # action: callback_verify, controller: admin/freshbooks
      # name=callback.verify&object_id=1&system=https%3A%2F%2F2ndsite.freshbooks.com&user_id=1&verifier=3bPTNcPgbN76QLgKLSR9XdgQJWvhhN4xrT
      post webhooks_path, "name " => "callback.verify", verifier: "3bPTNcPgbN76QLgKLSR9XdgQJWvhhN4xrT", system: "https://skunkwerxperformanceautomotivellc.freshbooks.com"
      expect(response.status).to eq(200)
      expect(flash[:notice]).to_not eq(nil)

      callback_delete("item.create")
    end
  end
end