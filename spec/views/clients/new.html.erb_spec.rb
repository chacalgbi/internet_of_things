require 'rails_helper'

RSpec.describe "clients/new", type: :view do
  before(:each) do
    assign(:client, Client.new(
      name: "MyString",
      email: "MyString",
      cel: "MyString",
      address_mqtt: "MyString",
      obs: "MyString"
    ))
  end

  it "renders new client form" do
    render

    assert_select "form[action=?][method=?]", clients_path, "post" do

      assert_select "input[name=?]", "client[name]"

      assert_select "input[name=?]", "client[email]"

      assert_select "input[name=?]", "client[cel]"

      assert_select "input[name=?]", "client[address_mqtt]"

      assert_select "input[name=?]", "client[obs]"
    end
  end
end
