require 'test_helper'
include SessionsHelper
class CreateMaloneTuneTest < ActionDispatch::IntegrationTest
  setup do
    @admin = FactoryGirl.create(:admin)
    post "/admin/sessions", session: { email: @admin.email, password: "foobar" }
    assert_response :redirect
  end

  # test "Get malone_tuning_index" do
  #   get "/malone_tunings_vehicles"
  #   assert_response :success
  # end

  # assigns - method to access params
  # send - dynamically call a method
  test "Create tune" do
    skip
    get_new_tuning
    new_url = css_select('input[value="Create as Tune"]').first.parent.attributes["action"]
    # Select 'Create as Tune' admin/malone_tunes/new
    get new_url, assigns[:malone_tunings].first.attributes
    create_url = css_select('input[value="Submit"]').first.parent.parent.parent.parent.parent.attributes["action"]
    verb = css_select('input[value="Submit"]').first.parent.parent.parent.parent.parent.attributes["method"]
    # Create tune
    assert_difference 'MaloneTune.count', +1 do
      self.send verb, create_url, { malone_tune: assigns[:malone_tune].attributes }
    end
    assert assigns(@malone_tune)
  end

  test "Create option" do
    skip
    get_new_tuning
    new_url = css_select('input[value="Create as Option"]').first.parent.attributes["action"]
    # Select 'Create as Option' admin/options/new
    get new_url, assigns[:malone_tunings].first.attributes
    create_url = css_select('input[value="Submit"]').first.parent.parent.parent.parent.parent.attributes["action"]
    verb = css_select('input[value="Submit"]').first.parent.parent.parent.parent.parent.attributes["method"]
    # Create option
    assert_difference 'Option.count', +1 do
      self.send verb, create_url, { option: assigns[:option].attributes }
    end
    assert assigns(@option)
  end

  test "Check that malone_tuning is removed from list" do

    # get_new_tuning
  end

  private

    def get_new_tuning
      # Index of engines
      get "/malone_tunings_vehicles"
      # Select first set of engine tunings.
      create_url = css_select("input[value='Select']").first.parent.parent.attributes["action"]
      # Create malone_tunings for selected engines
      post create_url # post '/admin/malone_tunings' ( :create )
      assert_template :index
    end
end

