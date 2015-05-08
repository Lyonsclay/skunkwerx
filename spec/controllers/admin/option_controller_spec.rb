require 'rails_helper'
include SessionsHelper

describe Admin::OptionsController do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:malone_tuning) { FactoryGirl.create(:malone_tuning) }
  let(:tuning_params) { { name: malone_tuning.name, unit_cost: malone_tuning.unit_cost } } 
  let(:malone_tune) { FactoryGirl.create(:malone_tune) } 

  before do
    sign_in(admin)
  end

  describe "POST create" do
    before do
      post :create, { option: tuning_params.merge({ malone_tune_id: malone_tune.id }) } 
    end
    
    it "sets the image to default if none found" do
      expect(Option.last.image.url).to eq('original/tune_missing.png')
    end

    it "assigns a malone_tune to option" do
      expect(Option.last.malone_tune).to eq(malone_tune)
    end
  end
end
