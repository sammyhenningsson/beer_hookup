require 'rails_helper'

RSpec.describe "/beers", type: :request do
  def brew(id:, name:)
    data = JSON.parse(file_fixture("beers.json").read).first
    data["id"] = id
    data["name"] = name
    Beer.create!(external_id: id, data:)
  end

  describe "GET /index" do
    it "renders a successful response" do
      brew(id: 1, name: "first brew")
      brew(id: 2, name: "second brew")
      get beers_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      beer = brew(id: 1, name: "first brew")
      get beer_url(beer)
      expect(response).to be_successful
    end
  end
end
