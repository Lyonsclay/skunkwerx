require 'rails_helper'
require 'capybara/rspec'
include Features::FreshbooksItemsHelpers

describe "Create new MaloneTuning", api: true do
  let!(:admin) {FactoryGirl.create(:admin)}
  before do
    MaloneTuning.delete_all
    visit login_path
    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button "Log in"
    visit malone_tuning_builders_vehicles_path
  end

  describe "Get malone_tuning_builder_index" do
    it "grabs many vehicle engine types " do
      # This test result is hinged upon the number of engine types
      # listed on the Malone Tuning website. Failure of this test
      # indicates a change in the website layout that might break
      # some of the code in admin/malone_tunings_helper.rb!
      expect(page).to have_selector('tr', count: 28)
    end
  end

  describe "Create and destroy new malone_tuning", freshbooks_items: true, js: true do
    before do
      first('tr').click_link('View')
      sleep 10
      expect(find('h2', match: :first).text).to have_content("Model Tunes for")
    end

    it "creates and destroys first tune" do
      first("input[type='checkbox']").set(true)
      expect{ click_button "Submit" }.to change(MaloneTuning, :count).by(1)
      wait_for_ajax
      expect(find("div.notice")).to have_content("Succesfully sent data:-/")
      item_id = MaloneTuning.order(item_id: :asc).first.item_id
      # If item_id is set the tune has been created on Freshbooks
      # database.
      expect(item_id).not_to be_nil
      # Get the item_id with the maximum value which in theory should
      # be the the most recently create malone_tuning.
      response = tune_destroy(item_id)
      expect(response["response"]["status"]).to eq("ok")
    end
  end
end
