require 'spec_helper'
require 'capybara/rspec'

include Features::WebhooksTestHelpers

describe "Get products from Skunkwerx index" do

  it "Provides array of products" do
    skunkwerx_get_products("tan")
  end
end
