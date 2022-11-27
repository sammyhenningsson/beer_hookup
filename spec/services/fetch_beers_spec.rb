# frozen_string_literal: true

require "rails_helper"

RSpec.describe FetchBeers do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:client) { PunkApi::Client.new(adapter: [:test, stubs]) }
  let(:data) { file_fixture("beers.json").read }

  before do
    allow(PunkApi::Client).to receive(:new).and_return(client)
  end

  it "fetch beers and stores the result" do
    stubs.get("/v2/beers") { [200, {"Content-Type" => "application/json"}, data] }

    expect {
      beers = FetchBeers.call
      expect(beers.map(&:class).uniq).to eq([Beer])
    }.to change(Beer, :count).by(12)
  end

  it "does not persit new beers when already existing" do
    parsed = JSON.parse(data)
    first_two = JSON.generate(parsed[..1])
    first_four = JSON.generate(parsed[..3])
    stubs.get("/v2/beers?page=1&per_page=2") { [200, {"Content-Type" => "application/json"}, first_two] }
    stubs.get("/v2/beers?page=1&per_page=4") { [200, {"Content-Type" => "application/json"}, first_four] }

    expect {
      beers = FetchBeers.call(per_page: 2)
      expect(beers.size).to eq(2)
    }.to change(Beer, :count).by(2)

    expect {
      beers = FetchBeers.call(per_page: 4)
      expect(beers.size).to eq(4)
    }.to change(Beer, :count).by(2)
  end
end
