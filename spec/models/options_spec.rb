require 'rails_helper'

describe Option do
  let(:option) { FactoryGirl.create :option }

  subject { option }

  it { should be_valid }

  it 'should have same attributes as MaloneTune' do
   expect(Option.attribute_names - ['malone_tune_id']).to match_array(MaloneTune.attribute_names - ['vehicle_id'])
  end

  describe Option do
    it { is_expected.to belong_to(:malone_tune) }
  end

  describe '.name' do
    it { expect(option[:name]).to eq('Option - ' + option.to_s) }
  end
end

