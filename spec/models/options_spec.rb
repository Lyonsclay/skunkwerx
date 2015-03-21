require 'rails_helper'

describe Option do
  let(:option) { FactoryGirl.create :option }
  # before do
  #   @option = FactoryGirl.create(:option)
  #   @tune = FactoryGirl.create(:malone_tune)
  # end

  subject { option }

  it { should be_valid }

  it "should have same attributes as MaloneTune" do
   expect(Option.attribute_names - ["malone_tune_id"]).to match_array(MaloneTune.attribute_names)
  end

  describe Option do
    it { is_expected.to belong_to(:malone_tune) }
  end

  describe ".name" do
    it { expect(option[:name]).to eq("Option::" + option.name) }
  end
end

