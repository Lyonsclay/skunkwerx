require 'test_helper'
include SessionsHelper
class CreateMaloneTuneTest < ActionDispatch::IntegrationTest
  setup do
    @admin = FactoryGirl.create(:admin)
    post "/admin/sessions", session: { email: @admin.email, password: "foobar" }
    assert_response :redirect
    # visit login_path
    # fill_in "Email", with: @admin.email
    # fill_in "Password", with: @admin.password
    # click_on "Log in"
  end

  test "Get malone_tuning_index" do
    get "/malone_tunings_vehicles"
    assert_response :success
  end

  test "Select tune for edit" do
    get "/malone_tunings_vehicles"
    edit_url = css_select("a").first.attributes["href"]
    get edit_url # get '/admin/malone_tunings' ( :index )
    assert_response :success
    select_tune = css_select("input[value='Submit']").first.parent.attributes
    puts "************************ select_tune:"
    puts select_tune
    # assigns
    # get '/admin/malone_tunings/:id' ( :show )
    get select_tune["action"], { tune: select_tune["tune"] }
    assert_response :success

binding.pry
#     visit malone_tuning_index_path
# binding.pry
#     first("a", text: "View").click
#     first("textarea").set "Gift Horse"
#     first(:xpath, "//input[@value='Submit']").click
# binding.pry
  end
end
