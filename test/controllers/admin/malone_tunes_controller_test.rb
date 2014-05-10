require 'test_helper'

class Admin::MaloneTunesControllerTest < ActionController::TestCase
  setup do
    @admin = Admin.create(email: "jack@this.com", password: "foobar", password_confirmation: "foobar", remember_token: "skullaflooda")
  end

  test "GET index should give status ok" do
    # Allow current_admin to return @admin
    # cookies.permanent[:remember_token] = @admin.remember_token
    @controller.sign_in(@admin)
    get :index
    assert_response :success
    assert_not_nil assigns(@models)
    assert_template(:index)
  end
end