require 'spec_helper'

describe "line_items/index" do
  before(:each) do
    assign(:line_items, [
      stub_model(LineItem,
        :product => nil,
        :cart => nil
      ),
      stub_model(LineItem,
        :product => nil,
        :cart => nil
      )
    ])
  end

  it "renders a list of line_items" do
    render
    line_item = @_encapsulated_assigns[:line_items].first
    assert_select "tr>td>a[href=?]", line_item_path(line_item)
    assert_select "tr>td>a[href=#{line_item_path(line_item)}]", text: "Show"
  end
end
