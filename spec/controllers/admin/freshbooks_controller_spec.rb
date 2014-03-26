require 'spec_helper'
require 'pry'

describe Admin::FreshbooksController do
  let(:admin) { create(:admin) }

  describe "GET index" do
    it "retrieves the index" do
      get :index

      expect(response).to render_template("index")
    end
  end

  describe "Freshbooks :items_sync" do
    it "should get items from freshbooks" do
      controller.stub(:current_admin).and_return(true)
      expect(Product.last).to eq(nil)
      get :items_sync
      expect(response).should redirect_to '/admin'
      expect(Product.last).not_to eq(nil)
    end
  end
end
