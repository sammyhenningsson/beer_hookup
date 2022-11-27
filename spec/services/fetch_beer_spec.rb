# frozen_string_literal: true

require "rails_helper"

RSpec.describe FetchBeer, type: :model do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:client) { PunkApi::Client.new(adapter: [:test, stubs]) }
  let(:beer_hash) { JSON.parse(file_fixture("beers.json").read).first }
  let(:id) { beer_hash["id"] }
  let(:data) { JSON.generate([beer_hash]) }

  before do
    allow(PunkApi::Client).to receive(:new).and_return(client)
  end

  it "fetch beers and stores the result" do
    stubs.get("/v2/beers/#{id}") { [200, {"Content-Type" => "application/json"}, data] }

    expect {
      beer = FetchBeer.call(external_id: id)
      expect(beer.class).to eq(Beer)
      expect(beer.name).to eq(beer_hash["name"])
    }.to change(Beer, :count).by(1)
  end

  it "does not persit new beers when already existing" do
    Beer.create!(data: beer_hash)

    expect {
      beer = FetchBeer.call(external_id: id)
      expect(beer.name).to eq(beer_hash["name"])
    }.to_not change(Beer, :count)
  end
end
