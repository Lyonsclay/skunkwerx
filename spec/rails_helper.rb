# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Hartl tutorial in 3rd edition will adopt newer technique of feature specs.
  # config.include Capybara::DSL

  # From Factory Girl README
  # https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md
  config.include FactoryGirl::Syntax::Methods

  config.include(MailerMacros)
  config.before(:each) { reset_email }

  config.include Features::WebhooksTestHelpers
  config.include Features::FreshbooksItemsHelpers

  # Run tests with external api calls.
  config.filter_run_excluding api: true unless ENV['API'] == "run"
  # Run tests that request and delete actual Freshbooks webhooks.
  config.filter_run_excluding webhooks: true unless ENV['WEBHOOKS'] == "run"
  # Run tests that create and destroy an item on the Freshbooks database.
  config.filter_run_excluding freshbooks_items: true unless ENV['FRESHBOOKS_ITEMS'] == "run"
  config.include RSpec::Rails::RequestExampleGroup, type: :feature
end

# Capybara.always_include_port = true

# Capybara.register_driver :rack_test do |app|
#   Capybara::RackTest::Driver.new(app, :headers => { 'HTTP_USER_AGENT' => 'Capybara' })
# end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app)
end

Capybara.run_server = true
Capybara.server_port = 3000
Capybara.app_host = "http://localhost:#{Capybara.server_port}"
