require 'rails_helper'

RSpec.describe "channels/edit", type: :view do
  let(:channel) {
    Channel.create!(
      category: "MyString",
      platform: "MyString",
      path: "MyString",
      type: "",
      color: "MyString",
      range: "MyString",
      array_info: "MyString",
      label: "MyString",
      previous_state: "MyString",
      obs: "MyString"
    )
  }

  before(:each) do
    assign(:channel, channel)
  end

  it "renders the edit channel form" do
    render

    assert_select "form[action=?][method=?]", channel_path(channel), "post" do

      assert_select "input[name=?]", "channel[category]"

      assert_select "input[name=?]", "channel[platform]"

      assert_select "input[name=?]", "channel[path]"

      assert_select "input[name=?]", "channel[type]"

      assert_select "input[name=?]", "channel[color]"

      assert_select "input[name=?]", "channel[range]"

      assert_select "input[name=?]", "channel[array_info]"

      assert_select "input[name=?]", "channel[label]"

      assert_select "input[name=?]", "channel[previous_state]"

      assert_select "input[name=?]", "channel[obs]"
    end
  end
end
