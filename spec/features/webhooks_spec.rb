require 'spec_helper'
require 'capybara/rspec'
include Features::CallbackHelpers
include Admin::FreshbooksHelper
# The following tests call methods that only live in the test
# suite. In this case using the rspec test space for these calls
# separates the webhooks requests from the admin panel, so that
# only the developer has access to these methods.

# The byproduct of these tests is that they perform the tasks
# described. Therefore this routine resets all webhooks that
# the Skunkwerx app is subscribing to.
describe "Describe Freshbooks webhooks", webhooks: true do
  before do
    admin = FactoryGirl.create(:admin)
    SessionsHelper.stub(:current_admin).and_return(admin)
  end

  describe "Delete all webhooks" do
    it "deletes all registered webhooks" do
      delete_all_webhooks
      doc = Document.new callbacks_display.to_xml
      total = REXML::XPath.first(doc, '//total')
      expect(total.text.to_i).to eq(0)
    end
  end

  describe "Request webhooks" do
    it "requests an item.create webhook" do
      # Get admin_freshbooks_path provides controller methods
      # and variables such as flash which is neccesary for
      # callback create.
      get admin_freshbooks_path
      callback_create "item.create"
      expect(get_callback_verify("item.create")).to eq("1")
    end

    it "requests an item.update webhook" do
      get admin_freshbooks_path
      callback_create "item.update"
      expect(get_callback_verify("item.update")).to eq("1")
    end

    it "Request item.delete webhook" do
      get admin_freshbooks_path
      callback_create "item.delete"
      expect(get_callback_verify("item.delete")).to eq("1")
    end
  end
end