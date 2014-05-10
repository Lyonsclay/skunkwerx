require 'test_helper'
include Admin::SessionsHelper

class AdminControllerTest < ActionController::TestCase
  test "should redirect to admin/sessions#new" do
    get :index
    assert_response :redirect
    assert_redirected_to(controller: "admin/sessions", action: "new")
  end


  test "should get admin/index" do
    sign_in(Admin.first)
    get :index
    assert_response :success
    assert_template :index
    # assert_response '.menu_bar ul li', 'HOME'
  end
end
