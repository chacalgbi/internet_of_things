require 'rails_helper'

RSpec.describe "devices/index", type: :view do
  before(:each) do
    assign(:devices, [
      Device.create!(
        description: "Description",
        device: "Device",
        token: "Token",
        tipo: "Tipo",
        versao: "Versao",
        linkAjuda: "Link Ajuda",
        pathUpdate: "Path Update",
        obs: "Obs",
        references: "References",
        client: "Client"
      ),
      Device.create!(
        description: "Description",
        device: "Device",
        token: "Token",
        tipo: "Tipo",
        versao: "Versao",
        linkAjuda: "Link Ajuda",
        pathUpdate: "Path Update",
        obs: "Obs",
        references: "References",
        client: "Client"
      )
    ])
  end

  it "renders a list of devices" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Device".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Token".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Tipo".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Versao".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Link Ajuda".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Path Update".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Obs".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("References".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Client".to_s), count: 2
  end
end
