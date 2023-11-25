require 'rails_helper'

RSpec.describe "channels/index", type: :view do
  before(:each) do
    assign(:channels, [
      Channel.create!(
        category: "Category",
        platform: "Platform",
        path: "Path",
        type: "Type",
        color: "Color",
        range: "Range",
        array_info: "Array Info",
        label: "Label",
        previous_state: "Previous State",
        obs: "Obs"
      ),
      Channel.create!(
        category: "Category",
        platform: "Platform",
        path: "Path",
        type: "Type",
        color: "Color",
        range: "Range",
        array_info: "Array Info",
        label: "Label",
        previous_state: "Previous State",
        obs: "Obs"
      )
    ])
  end

  it "renders a list of channels" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Category".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Platform".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Path".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Color".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Range".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Array Info".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Label".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Previous State".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Obs".to_s), count: 2
  end
end
