require 'rails_helper'
include SessionsHelper

describe Admin::ProductsController do
  let(:admin) { FactoryGirl.create(:admin) }

  describe "GET " do
    it "fails to render index form" do
      get :index
      expect(response).to redirect_to "/"
    end

    it "renders the index form" do
      sign_in(admin)
      get :index
      expect(response).to render_template("index")
    end
  end
end
