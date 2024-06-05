require 'rails_helper'

RSpec.describe "clients/index", type: :view do
  before(:each) do
    assign(:clients, [
      Client.create!(
        name: "Name",
        email: "Email",
        cel: "Cel",
        address_mqtt: "Address Mqtt",
        obs: "Obs"
      ),
      Client.create!(
        name: "Name",
        email: "Email",
        cel: "Cel",
        address_mqtt: "Address Mqtt",
        obs: "Obs"
      )
    ])
  end

  it "renders a list of clients" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cel".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Address Mqtt".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Obs".to_s), count: 2
  end
end
