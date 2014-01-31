require 'test_helper'
require 'capybara/rails'
require 'capybara/dsl'
Capybara.default_driver = :selenium

class ContactPageTest < ActionDispatch::IntegrationTest
  test "welcome page has CONTACT button in menu bar" do
    get "/"
    assert_response :success
    assert_template "index"
  end

  test "CONTACT button leads to contact page" do
    visit root_path

    find(".menu_bar").click_link("CONTACT")
    page.has_content?('(502)')

  end
end
