require 'spec_helper'

describe Admin::FreshbooksController do
  # Create FactoryGirl admin
  let(:admin) { create(:admin) }
  before(:each) do
    Product.delete_all
  end

  describe "GET index", api: true do
    it "retrieves the index" do
      controller.stub(:current_admin).and_return(true)
      get :index
      expect(response).to render_template("index")
    end
  end

  # This test actually calls api!
  describe "Freshbooks :items_sync", api: true do
    it "should get items from freshbooks" do
      controller.stub(:current_admin).and_return(true)
      expect(Product.last).to eq(nil)
      get :items_sync
      expect(response).to redirect_to '/admin'
      expect(Product.last).not_to eq(nil)
      expect(flash[:sync_discrepancy]).to include("The following products were newly created")
    end
  end

  describe "Test helper methods" do
    it "should return an xml message" do
      expect(subject.send(:item_list_message, 1)).to include("<request method=\"item.list\">")
    end
  end

  it "makes a call to Freshbooks api", api: true do
    # This method calls actual Freshbooks api
    controller.sign_in(admin)
    post :webhook_create, method: "item.create"
    expect(response).to redirect_to('/admin')
    expect(Rails.cache.read "callback_id").to_not eq(nil)
    post :webhooks, "name" => "callback.verify", verifier: "not_valid_verifier", system: "https://skunkwerxperformanceautomotivellc.freshbooks.com"
    expect(response.status).to eq(200)
    puts "****************** rspec post :webhooks ***************"
    puts "flash[:notice]: " + flash[:notice].to_s
    puts "********************************************************"
    # expect(flash[:notice]).to_not eq(nil)
    expect(flash[:notice]["response"]["xmlns"]).to eq("http://www.freshbooks.com/api/")
  end
end
