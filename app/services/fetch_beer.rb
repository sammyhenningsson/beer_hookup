# frozen_string_literal: true

class FetchBeer
  attr_reader :external_id

  def self.call(external_id:)
    new(external_id:).call
  end

  def initialize(external_id:)
    @external_id = external_id
  end

  def call
    beer = Beer.find_or_initialize_by(external_id:)
    return beer if beer.persisted?

    beer.data = client.beer(id: external_id)
    beer.save!
    beer
  end

  private

  def client
    PunkApi::Client.new
  end
end
