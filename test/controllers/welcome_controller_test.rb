require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase

  test "should get index" do
    @request.headers["HTTP_REFERER"] = "http://localhost:3000"
    get :index
    assert_response :success
  end

  test "index should render correct template and layout" do
    get :index
    assert_template :index
    assert_template layout: "layouts/application"
  end

  test "footer content should contain 'by appointment only'" do
    get :index
    assert_select ".footer p", /by appointment only/
  end

  test "menu should have 'contact' button" do
    get :index
    assert_select ".menu_bar ul>li", "CONTACT"
  end
end
