require 'rails_helper'
include SessionsHelper

describe Admin::MaloneTunesController do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:malone_tuning) { FactoryGirl.create(:malone_tuning) }
  
  before do
    sign_in(admin)
  end

  describe "POST create" do
    it "sets the image to default if none found" do
      byebug
      post :create, malone_tune: { name: malone_tuning.name } 
      expect(MaloneTun.last.image.url).to eq('original/tune_missing.png')
    end
  end
end
