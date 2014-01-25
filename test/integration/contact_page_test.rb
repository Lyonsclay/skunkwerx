require 'test_helper'
require 'capybara/rails'
# Capybara.default_driver = :selenium

class ContactPageTest < ActionDispatch::IntegrationTest
  test "welcome page has CONTACT button in menu bar" do
    https!
    get "/"
    assert_response :success
    assert_template "index"
  end

    test "CONTACT button leads to contact page" do
    visit("/")
    click_link("CONTACT")

  end
end
