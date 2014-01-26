require 'test_helper'
require 'capybara/rails'
require 'capybara/dsl'
# Capybara.default_driver = :selenium

class ContactPageTest < ActionDispatch::IntegrationTest
  test "welcome page has CONTACT button in menu bar" do
    get "/"
    assert_response :success
    assert_template "index"
  end

  test "CONTACT button leads to contact page" do
    get "/"
    click_link("CONTACT")
    follow_redirect!
  end
end
