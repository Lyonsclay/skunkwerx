require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  fixtures :admin

  test "https login" do
    https!
    get login_path
    assert_response :success
    post_via_redirect '/admin/sessions', session: { email: admin(:admin_one).email, password: "jackalack" }
    assert_equal '/admin', path
    https!(false)
    get '/admin/products'
    assert_response :success
    assert assigns(:products)
  end

  test "visit '/admin' page and login if no sessions current" do
    admin = login(:admin_one)
    admin_two = login(:admin_two)
    admin.visits_site
    admin_two.visits_site
  end

  private

    module CustomDsl
      def visits_site
        get_via_redirect "/admin"
        assert_response :success
        assert_equal '/admin/login', path
      end
    end

    def login(admin)
      open_session do |sess|
        # Add methods to sess from module CustomDsl as singleton methods.
        sess.extend(CustomDsl)
        u = admin(admin)
        sess.https!
        sess.post "/admin/sessions", session: { email: u.email, password: "foobar" }
        sess.assert_response :success
        sess.https!(false)
      end
    end
end