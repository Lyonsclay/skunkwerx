require 'rails_helper'
include SessionsHelper
include FreshbooksCallbacks
include Admin::FreshbooksHelper

describe Admin::FreshbooksController do
  # Create FactoryGirl admin
  let(:admin) { FactoryGirl.create(:admin) }
  before(:each) do
    Product.delete_all
    sign_in(admin)
  end

  describe "GET index", api: true do
    it "retrieves the index" do
      get :index
      expect(response).to render_template("index")
    end
  end

  # This test actually calls api!
  describe "Freshbooks :items_sync", api: true do
    it "should get items from freshbooks" do
      sign_in(admin)
      expect(Product.last).to eq(nil)
      get :items_sync
      expect(response).to redirect_to '/admin'
      expect(Product.last).not_to eq(nil)
      expect(session[:sync_discrepancy]).to include("The following products were newly created")
    end
  end

  describe "Test helper methods" do
    it "should return an xml message" do
      expect(subject.send(:item_list_message, 1)).to include("<request method=\"item.list\">")
    end
  end

  it "creates an item.create webhook", api: true do
    # This method calls actual Freshbooks api
    controller.sign_in(admin)
    post :webhook_create, method: "item.create"
    expect(response).to redirect_to('/admin')
    expect(Rails.cache.read "callback_id").to_not eq(nil)
    # Mimic Freshbooks API call to Skunkwerx app
    post :webhooks, "name" => "callback.verify", verifier: "not_valid_verifier", system: "https://skunkwerxperformanceautomotivellc.freshbooks.com"
    expect(response.status).to eq(200)
    puts "****************** rspec post :webhooks ***************"
    puts "flash[:notice]: " + flash[:notice].to_s
    puts "********************************************************"
    # expect(flash[:notice]).to_not eq(nil)
    expect(flash[:notice]["response"]["xmlns"]).to eq("http://www.freshbooks.com/api/")
  end

  it "deletes all unverified callbacks" do
    # delete_unverified_callbacks
    # expect(get_callbacks_list.select { |c| c["verified"] == "0" }).to be_empty
  end

  # Create and Destroy Freshbooks webhooks
  describe "Describe create and destroy Freshbooks webhooks", webhooks: true do
    # before do
    #   admin = FactoryGirl.create(:admin)
    #   # SessionsHelper.stub(:current_admin).and_return(admin)
    #   sign_in(admin)
    # end

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
        callback_create "item.create"
        expect(get_callback_verify("item.create")).to eq("1")
      end

      it "requests an item.update webhook" do
        callback_create "item.update"
        expect(get_callback_verify("item.update")).to eq("1")
      end

      it "Request item.delete webhook" do
        callback_create "item.delete"
        expect(get_callback_verify("item.delete")).to eq("1")
      end
    end
  end
end
