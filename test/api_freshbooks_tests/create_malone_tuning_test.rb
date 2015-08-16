require 'test_helper'
include SessionsHelper
class CreateMaloneTuningTest < ActionDispatch::IntegrationTest
  setup do
    @admin = FactoryGirl.create(:admin)
    post "/admin/sessions", session: { email: @admin.email, password: "foobar" }
    assert_response :redirect
  end

  # test "Get malone_tuning_builder_index" do
  #   get "/malone_tuning_builders_vehicles"
  #   assert_response :success
  # end

  # assigns - method to access params
  # send - dynamically call a method
  test "Create tune" do
    skip
    get_new_tuning
    new_url = css_select('input[value="Create as Tune"]').first.parent.attributes["action"]
    # Select 'Create as Tune' admin/malone_tunings/new
    get new_url, assigns[:malone_tuning_builders].first.attributes
    create_url = css_select('input[value="Submit"]').first.parent.parent.parent.parent.parent.attributes["action"]
    verb = css_select('input[value="Submit"]').first.parent.parent.parent.parent.parent.attributes["method"]
    # Create tune
    assert_difference 'MaloneTuning.count', +1 do
      self.send verb, create_url, { malone_tuning: assigns[:malone_tuning].attributes }
    end
    assert assigns(@malone_tuning)
  end

  test "Create option" do
    skip
    get_new_tuning
    new_url = css_select('input[value="Create as Option"]').first.parent.attributes["action"]
    # Select 'Create as Option' admin/options/new
    get new_url, assigns[:malone_tuning_builders].first.attributes
    create_url = css_select('input[value="Submit"]').first.parent.parent.parent.parent.parent.attributes["action"]
    verb = css_select('input[value="Submit"]').first.parent.parent.parent.parent.parent.attributes["method"]
    # Create option
    assert_difference 'Option.count', +1 do
      self.send verb, create_url, { option: assigns[:option].attributes }
    end
    assert assigns(@option)
  end

  test "Check that malone_tuning_builder is removed from list" do

    # get_new_tuning
  end

  private

    def get_new_tuning
      # Index of engines
      get "/malone_tuning_builders_vehicles"
      # Select first set of engine tunings.
      create_url = css_select("input[value='Select']").first.parent.parent.attributes["action"]
      # Create malone_tuning_builders for selected engines
      post create_url # post '/admin/malone_tuning_builders' ( :create )
      assert_template :index
    end
end

