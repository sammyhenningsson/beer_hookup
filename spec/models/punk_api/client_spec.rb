# frozen_string_literal: true

require "rails_helper"

module PunkApi
  RSpec.describe Client, type: :model do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:client) { Client.new(adapter: [:test, stubs]) }

    it "can fetch a list of beers" do
      data = file_fixture("beers.json").read
      stubs.get("/v2/beers") { [200, {"Content-Type" => "application/json"}, data] }

      beers = client.beers

      expect(beers.size).to eq(12)
      expect(beers.pluck("name")).to eq(
        [
          "Pilsen Lager",
          "Fake Lager",
          "India Session Lager - Prototype Challenge",
          "Black Tokyo Horizon (w/Nøgne Ø & Mikkeller)",
          "77 Lager",
          "This. Is. Lager",
          "Cult Lager",
          "Barrel Aged Hinterland",
          "Small Batch: Mandarina Lager",
          "Clockwork Tangerine",
          "Interstate Vienna Lager.",
          "Fools Gold Dortmunder Lager"
        ]
      )
    end

    it "can makes request with correct query params and Accept header" do
      data = file_fixture("beers.json").read
      stubs.strict_mode = true # verify that we get pagination query params only.
      stubs.get("/v2/beers?page=1&per_page=10", {"Accept" => "application/json"}) do
        [200, {"Content-Type" => "application/json"}, data]
      end

      beers = client.beers

      expect(beers.size).to eq(12)
      expect(beers.pluck("name")).to eq(
        [
          "Pilsen Lager",
          "Fake Lager",
          "India Session Lager - Prototype Challenge",
          "Black Tokyo Horizon (w/Nøgne Ø & Mikkeller)",
          "77 Lager",
          "This. Is. Lager",
          "Cult Lager",
          "Barrel Aged Hinterland",
          "Small Batch: Mandarina Lager",
          "Clockwork Tangerine",
          "Interstate Vienna Lager.",
          "Fools Gold Dortmunder Lager"
        ]
      )
    end

    it "can filter by name" do
      data = file_fixture("candy.json").read
      stubs.get("/v2/beers?beer_name=candy") { [200, {"Content-Type" => "application/json"}, data] }

      beers = client.beers(name: "candy")

      expect(beers.size).to eq(2)
      expect(beers.pluck("name")).to eq(
        [
          "Skull Candy",
          "Candy Kaiser"
        ]
      )
    end

    it "can paginate" do
      data = file_fixture("candy.json").read
      stubs.get("/v2/beers?page=5&per_page=15") { [200, {"Content-Type" => "application/json"}, data] }

      beers = client.beers(page: 5, per_page: 15)

      expect(beers.size).to eq(2)
      expect(beers.pluck("name")).to eq(
        [
          "Skull Candy",
          "Candy Kaiser"
        ]
      )
    end

    it "can paginate" do
      data = file_fixture("candy.json").read
      stubs.get("/v2/beers?page=5&per_page=15") { [200, {"Content-Type" => "application/json"}, data] }

      beers = client.beers(page: 5, per_page: 15)

      expect(beers.size).to eq(2)
      expect(beers.pluck("name")).to eq(
        [
          "Skull Candy",
          "Candy Kaiser"
        ]
      )
    end

    it "can handle a server error" do
      stubs.get("/v2/beers") { [500, {"Content-Type" => "application/json"}, '{"msg": "boom"}'] }

      expect {
        client.beers
      }.to raise_error(Client::Error)
    end
  end
end
