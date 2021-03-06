require 'rails_helper'
require 'capybara/rspec'

include Features::WebhooksTestHelpers

describe "Get products from Skunkwerx index", freshbooks_items: true do

  it "Visits Skunkwerx products/index" do
    get(ENV['SKUNKWERX_URL'] + '/products/index')
    expect(response.status).to eq(200)
  end

  # Create unique name begining with "Goofy-rspec-".
  before(:all) do
    @name ||= "Goofy-rspec-" + SecureRandom.urlsafe_base64(nil, false)[1..5]
  end

  let(:item_id) { freshbooks_get_item_id }

  it "Creates new product" do
    products = skunkwerx_get_products.count
    response = freshbooks_create_product(@name)
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
    freshbooks_update_product(description)
    # Get description from Skunkwerx website.
    # Delay until producat has been updated and callback issues.
    num = 0
    until (skunkwerx_get_item_description == description) || num == 10 do
      num += 1
    end
    expect(skunkwerx_get_item_description).to eq(description)
  end

  it "Deletes new product" do
    products = skunkwerx_get_products.count
    response = freshbooks_destroy_products([item_id])
    # Delay until product has been deleted and callback issues.
    num = 0
    until (products - 1 == skunkwerx_get_products.count) || num == 10 do
      num += 1
    end
    products_new = skunkwerx_get_products.count
    expect(products_new - products).to eq(-1)
  end

  it "Deletes all 'Goofy' products" do
    freshbooks_destroy_products(get_goofy_item_ids)
    expect(get_goofy_item_ids).to eq([])
  end
end
