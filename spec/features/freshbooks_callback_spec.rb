require 'spec_helper'
require 'capybara/rspec'

describe "Freshbooks webhook request", api: true do
  describe "Post webhook_create" do
    it "has response success" do
    post admin_webhook_create_path
    expect(response.status).to eq(302)
    end

    it "makes a call to Freshbooks api" do
      admin = FactoryGirl.create(:admin)
      SessionsHelper.stub(:current_admin).and_return(admin)
      # This method calls actual Freshbooks api
      post admin_webhook_create_path, method: "item.create"
      expect(response.status).to redirect_to '/admin'
      expect(Rails.cache.read "callback_id").to_not eq(nil)
      post webhooks_path, "name " => "callback.verify", verifier: "3bPTNcPgbN76QLgKLSR9XdgQJWvhhN4xrT", system: "https://skunkwerxperformanceautomotivellc.freshbooks.com"
      expect(response.status).to eq(200)
      expect(flash[:notice]).to_not eq(nil)
    end
  end
end