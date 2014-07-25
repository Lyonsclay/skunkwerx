require 'rails_helper'

RSpec.describe "line_items/index", :type => :view do
  before(:each) do
    assign(:line_items, [
      LineItem.create!(),
      LineItem.create!()
    ])
  end

  it "renders a list of line_items" do
    render
  end
end
