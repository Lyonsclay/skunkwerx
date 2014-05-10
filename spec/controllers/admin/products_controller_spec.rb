require 'spec_helper'

describe Admin::ProductsController do
  let(:admin) { create(:admin) }

  describe "GET " do
    it "fails to render index form" do
      get :index
      expect(response).to redirect_to "/"
    end

    it "renders the index form" do
      controller.stub(:current_admin).and_return(true)
      get :index
      expect(response).to render_template("index")
    end
  end
end
