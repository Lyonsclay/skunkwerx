require 'rails_helper'
include SessionsHelper

describe Admin::MaloneTuningsController do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:build_vehicle) { build(:build_vehicle) }
  let(:select_vehicle) { build(:select_vehicle) }
  name_cost = { name: "SomGood", unit_cost: 120.25 }
  let(:malone_tuning_params) { { malone_tuning: name_cost } }

  before do
    allow(VehicleConnect).to receive_message_chain(:new, :associate).and_return(true)
    tune = instance_double("MaloneTuning", malone_tuning_params[:malone_tuning])
    sign_in(admin)
  end

  describe "POST create" do
    it "renders tuning_index" do
      post :create, malone_tuning_params.merge(build_vehicle)
      expect(response).to render_template("admin/malone_tuning_builders/tunings_index")
    end

    context "when an existing vehicle is selected" do
      it "creates a new tune" do
        post :create, malone_tuning_params.merge(select_vehicle)
        expect(MaloneTuning.last.name).to eq(name_cost[:name])
      end
    end

    context "when a new vehicle is created" do
      it "creates a new tune" do
        post :create, malone_tuning_params.merge(build_vehicle)
        expect(MaloneTuning.last.name).to eq(name_cost[:name])
      end
    end
  end
end
