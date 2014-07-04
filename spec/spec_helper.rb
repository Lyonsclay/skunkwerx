# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
# require 'coveralls'
# Coveralls.wear!

require 'rack/utils'
Capybara.app = Rack::ShowExceptions.new(Skunkwerx::Application)
Capybara.default_wait_time = 90

module Features
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  # config.order = "random"

  # Move integrations tests from spec/requests to spec/features
  # Capybara 2.+ requires this folder hiearchy
  config.include RSpec::Rails::RequestExampleGroup, type: :feature

  # Hartl tutorial in 3rd edition will adopt newer technique of feature specs.
  config.include Capybara::DSL

  # From Factory Girl README
  # https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md
  config.include FactoryGirl::Syntax::Methods

  config.include(MailerMacros)
  config.before(:each) { reset_email }

  config.include Features::CallbackHelpers
  config.include Features::WebhooksTestHelpers

  # Run tests with external api calls.
  config.filter_run_excluding api: true unless ENV['API'] == "run"
  # Run tests that request and delete actual Freshbooks webhooks.
  config.filter_run_excluding webhooks: true unless ENV['WEBHOOKS'] == "run"
  # Run tests that create and destroy an item on the Freshbooks database.
  config.filter_run_excluding freshbooks_items: true unless ENV['FRESHBOOKS_ITEMS'] == "run"
end
