source 'https://rubygems.org'

ruby "2.1.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn', group: :production

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
# gem 'pry'
gem 'byebug'

group :test do
  gem 'capybara'
  gem 'selenium-webdriver', '~> 2.38.0'
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'shoulda-matchers', require: false
end

# Enable Heroku static asset serving and logging on
gem 'rails_12factor', group: :production

# Uploading Files to S3
# Following Heroku tutorial https://devcenter.heroku.com/articles/paperclip-s3
gem 'paperclip'
gem 'aws-sdk'

# For fast caching in production
gem 'dalli', group: :production

# Travis CI runs rake by default to execute your tests. Please note that you need to add rake to your Gemfile.
gem 'rake', group: :test

# Coveralls
gem 'coveralls', require: false

# Gives ability to use ActiveRecord data store rather than Cookies
gem 'activerecord-session_store'

# Pagination gem
gem 'kaminari'

# Store configuration values securely
gem 'figaro'

