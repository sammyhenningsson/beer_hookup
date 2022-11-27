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
    client.beers(name: query, page:, per_page:).map do |data|
      upsert(data)
    end
  end

  private

  def client
    PunkApi::Client.new
  end

  def upsert(data)
    external_id = data["id"]
    beer = Beer.find_or_initialize_by(external_id:)
    beer.data = data
    beer.save!
    beer
  end
end
