require 'spec_helper'
require 'capybara/rspec'

include Features::WebhooksTestHelpers

describe "Get products from Skunkwerx index" do

  it "Provides array of products" do
    products = skunkwerx_get_products
    name = "Goofy-rspec" + SecureRandom.urlsafe_base64(nil, false)[1..5]
# binding.pry
    response = skunkwerx_create_product(name)
    item_id = skunkwerx_get_item_id(name)
# binding.pry
    products_new = skunkwerx_get_products
    expect(products_new.count - products.count).to eq(1)
    response = skunkwerx_destroy_product(item_id)
# binding.pry
    products = products_new
    products_new = skunkwerx_get_products
    expect(products_new.count - products.count).to eq(-1)
  end
end
