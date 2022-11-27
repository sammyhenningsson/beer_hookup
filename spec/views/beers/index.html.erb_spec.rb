require 'rails_helper'

RSpec.describe "beers/index", type: :view do
  before(:each) do
    assign(:beers, [
      Beer.create!(
        external_id: 2,
        data: "Data"
      ),
      Beer.create!(
        external_id: 2,
        data: "Data"
      )
    ])
  end

  it "renders a list of beers" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Data".to_s), count: 2
  end
end
