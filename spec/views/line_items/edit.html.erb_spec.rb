require 'spec_helper'

describe "line_items/edit" do
  before(:each) do
    @line_item = assign(:line_item, stub_model(LineItem,
      :product => nil,
      :cart => nil
    ))
  end

  it "renders the edit line_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", line_item_path(@line_item), "post" do
      assert_select "input#line_item_product[name=?]", "line_item[product]"
      assert_select "input#line_item_cart[name=?]", "line_item[cart]"
    end
  end
end
