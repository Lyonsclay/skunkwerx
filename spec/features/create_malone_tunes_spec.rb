require 'spec_helper'
require 'capybara/rspec'
# include Features::CallbackHelpers
# include Admin::MaloneTunesHelper
# include SessionsHelper

describe "Describe create new MaloneTunes", api: true do
  before do
    admin = FactoryGirl.create(:admin)
    visit login_path
    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Log in"
    visit malone_tuning_index_path
  end

  describe "Get malone_tuning_index" do
    it "grabs many vehicle engine types " do
      # This test result is hinged upon the number of engine types
      # listed on the Malone Tuning website. Failure of this test
      # indicates a change in the website layout that might break
      # some of the code in admin/malone_tunes_helper.rb!
      expect(page).to have_selector('tr', count: 27)
    end
  end

  describe "Get show the first listed engine's tunes" do
    before do
      first('tr').click_link('View')
    end

    it "grabs first engine's tunes" do
      expect(page).to have_text "Model Tunes for"
    end

    it "select first tune" do
      first("input[type='checkbox']").set(true)
      expect{ click_button "Submit" }.to change(MaloneTune, :count).by(1)
    end
  end
end