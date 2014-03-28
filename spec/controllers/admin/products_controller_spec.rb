require 'spec_helper'
require 'pry'

describe Admin::ProductsController do
  let(:admin) { create(:admin) }

  describe "GET " do
    it "renders the products/index form" do
      controller.stub(:current_admin).and_return(true)
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "create session" do
    it "should get products/edit with valid credentials" do
      get :index
    end

    it "should redirect to admin after valid login" do
    end
  end
end
