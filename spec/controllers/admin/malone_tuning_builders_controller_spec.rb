require 'rails_helper'
include SessionsHelper

describe Admin::MaloneTuningBuildersController do
  let(:admin) { FactoryGirl.create(:admin) }

  before { sign_in(admin) }

  describe "GET vehicle_index" do
    it "renders the index form" do
      allow(controller).to receive(:vehicle_models)

      get :vehicle_index

      expect(response).to render_template("vehicle_index")
    end
  end

   describe "GET tunings_index" do
    it "renders the index form" do
      allow(controller).to receive(:vehicle_tunings)

      get :tunings_index

      expect(response).to render_template("tunings_index")
    end
  end
end
