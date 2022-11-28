# frozen_string_literal: true

class FetchBeers
  PER_PAGE = 10

  attr_reader :query, :page, :per_page

  def self.call(query: nil, page: 1, per_page: PER_PAGE)
    new(query:, page:, per_page:).call
  end

  def initialize(page:, per_page:, query: nil)
    @query = query
    @page = page
    @per_page = per_page
  end

  def call
    upsert_all client.beers(name: query, page:, per_page:)
  end

  private

  def client
    PunkApi::Client.new
  end

  def upsert_all(data)
    external_ids = data.pluck("id")
    beers = Beer.where(external_id: external_ids).index_by(&:external_id)
    data.map do |beer_data|
      external_id = beer_data["id"]
      upsert(beers[external_id], beer_data)
    end
  end

  def upsert(beer, data)
    external_id = data["id"]
    beer ||= Beer.new(external_id:)
    beer.data = data
    beer.save!
    beer
  end
end
