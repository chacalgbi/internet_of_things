require 'rails_helper'

RSpec.describe "channels/show", type: :view do
  before(:each) do
    assign(:channel, Channel.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/Platform/)
    expect(rendered).to match(/Path/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Color/)
    expect(rendered).to match(/Range/)
    expect(rendered).to match(/Array Info/)
    expect(rendered).to match(/Label/)
    expect(rendered).to match(/Previous State/)
    expect(rendered).to match(/Obs/)
  end
end
