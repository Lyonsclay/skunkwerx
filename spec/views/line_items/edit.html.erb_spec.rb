require 'spec_helper'
include CurrentCart

describe "line_items/edit" do
  before(:each) do
    # product = FactoryGirl.create(:product)
    # set_cart
    # @line_item = @cart.add_product(product.id)
    @line_item = assign(:line_item, stub_model(LineItem,
      :product => FactoryGirl.create(:product),
      :cart => Cart.new
    ))
  end

  it "renders the edit line_item form" do
    render
    puts @_encapsulated_assigns
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", line_item_path(@line_item), "post" do

      assert_select "input#line_item_item_id[name=?]", "line_item[item_id]"
      assert_select "input#line_item_cart_id[name=?]", "line_item[cart_id]"
    end
  end
end
