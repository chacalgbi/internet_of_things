require 'rails_helper'

RSpec.describe "devices/edit", type: :view do
  let(:device) {
    Device.create!(
      description: "MyString",
      device: "MyString",
      token: "MyString",
      tipo: "MyString",
      versao: "MyString",
      linkAjuda: "MyString",
      pathUpdate: "MyString",
      obs: "MyString",
      references: "MyString",
      client: "MyString"
    )
  }

  before(:each) do
    assign(:device, device)
  end

  it "renders the edit device form" do
    render

    assert_select "form[action=?][method=?]", device_path(device), "post" do

      assert_select "input[name=?]", "device[description]"

      assert_select "input[name=?]", "device[device]"

      assert_select "input[name=?]", "device[token]"

      assert_select "input[name=?]", "device[tipo]"

      assert_select "input[name=?]", "device[versao]"

      assert_select "input[name=?]", "device[linkAjuda]"

      assert_select "input[name=?]", "device[pathUpdate]"

      assert_select "input[name=?]", "device[obs]"

      assert_select "input[name=?]", "device[references]"

      assert_select "input[name=?]", "device[client]"
    end
  end
end
