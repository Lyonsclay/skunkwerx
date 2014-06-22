require 'spec_helper'
require 'capybara/rspec'

include Features::WebhooksTestHelpers

describe "Get products from Skunkwerx index" do

  it "Visits Skunkwerx products/index" do
    get(ENV['SKUNKWERX_URL'] + '/products/index')
    expect(response.status).to eq(200)
  end

  before(:all) do
    @name ||= "Goofy-rspec-" + SecureRandom.urlsafe_base64(nil, false)[1..5]
  end

  let(:item_id) { skunkwerx_get_item_id }


  it "Creates new product" do
    products = skunkwerx_get_products.count
    response = skunkwerx_create_product(@name)
    # Delay until product has been created and callback issues.
    num = 0
    until (products + 1 == skunkwerx_get_products.count) || num == 10 do
      num += 1
    end
    products_new = skunkwerx_get_products.count
    expect(products_new - products).to eq(1)
  end

  it "Updates new product" do
    description = "Actually it's not so great."
    response_hash = skunkwerx_update_product(description)
binding.pry
    # Get description from Skunkwerx website.
    expect(skunkwerx_get_item_description).to eq(description)
  end

  it "Deletes new product" do
    products = skunkwerx_get_products.count
    response = skunkwerx_destroy_product
    # Delay until product has been deleted and callback issues.
    num = 0
    until (products - 1 == skunkwerx_get_products.count) || num == 10 do
      num += 1
    end
    products_new = skunkwerx_get_products.count
    expect(products_new - products).to eq(-1)
  end
end
