require 'rails_helper'

RSpec.describe "clients/show", type: :view do
  before(:each) do
    assign(:client, Client.create!(
      name: "Name",
      email: "Email",
      cel: "Cel",
      address_mqtt: "Address Mqtt",
      obs: "Obs"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Cel/)
    expect(rendered).to match(/Address Mqtt/)
    expect(rendered).to match(/Obs/)
  end
end
