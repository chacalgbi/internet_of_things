require 'rails_helper'

RSpec.describe "clients/edit", type: :view do
  let(:client) {
    Client.create!(
      name: "MyString",
      email: "MyString",
      cel: "MyString",
      address_mqtt: "MyString",
      obs: "MyString"
    )
  }

  before(:each) do
    assign(:client, client)
  end

  it "renders the edit client form" do
    render

    assert_select "form[action=?][method=?]", client_path(client), "post" do

      assert_select "input[name=?]", "client[name]"

      assert_select "input[name=?]", "client[email]"

      assert_select "input[name=?]", "client[cel]"

      assert_select "input[name=?]", "client[address_mqtt]"

      assert_select "input[name=?]", "client[obs]"
    end
  end
end
