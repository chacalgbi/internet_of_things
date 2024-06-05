require 'rails_helper'

RSpec.describe "devices/show", type: :view do
  before(:each) do
    assign(:device, Device.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Device/)
    expect(rendered).to match(/Token/)
    expect(rendered).to match(/Tipo/)
    expect(rendered).to match(/Versao/)
    expect(rendered).to match(/Link Ajuda/)
    expect(rendered).to match(/Path Update/)
    expect(rendered).to match(/Obs/)
    expect(rendered).to match(/References/)
    expect(rendered).to match(/Client/)
  end
end
