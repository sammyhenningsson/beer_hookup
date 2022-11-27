require 'rails_helper'

RSpec.describe "beers/show", type: :view do
  before(:each) do
    assign(:beer, Beer.create!(
      external_id: 2,
      data: "Data"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Data/)
  end
end
