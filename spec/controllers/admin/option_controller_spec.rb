require 'rails_helper'
include SessionsHelper

describe Admin::OptionsController do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:malone_tuning_builder) { FactoryGirl.create(:malone_tuning_builder) }
  let(:tuning_params) { { name: malone_tuning_builder.name, unit_cost: malone_tuning_builder.unit_cost } } 
  let(:malone_tuning) { FactoryGirl.create(:malone_tuning) } 

  before do
    sign_in(admin)
  end

  describe "POST create" do
    before do
      post :create, { option: tuning_params.merge({ malone_tuning_id: malone_tuning.id }) } 
    end
    
    it "sets the image to default if none found" do
      expect(Option.last.image.url).to eq('original/tune_missing.png')
    end

    it "assigns a malone_tuning to option" do
      expect(Option.last.malone_tuning).to eq(malone_tuning)
    end
  end
end
