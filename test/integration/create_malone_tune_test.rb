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
    # get "/malone_tuning_index"
    # assert_response :success
  end

  test "Select tune for edit" do
    get "/malone_tuning_index"
    edit_url = css_select("a").first.attributes["href"]
    get edit_url # get '/show'
    assert_response :success
    select_tune = css_select("form")[2].attributes
binding.pry
    # assigns
    # post select_tune["action"], { tune: select_tune["tune"] }
#     visit malone_tuning_index_path
# binding.pry
#     first("a", text: "View").click
#     first("textarea").set "Gift Horse"
#     first(:xpath, "//input[@value='Submit']").click
# binding.pry
  end
end
