require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  fixtures :admin

  test "visit '/admin' page and login if no sessions current" do
    admin = login(:admin_one)

    admin.visits_site

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
        sess.post "/sessions", session: { username: u.email, password: "foobar" }
# binding.pry
        sess.assert_response :success
        sess.https!(false)
      end
    end
end