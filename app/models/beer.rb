class Beer < ApplicationRecord
  attribute :data, BeerData.to_type
  validates :data, store_model: { merge_errors: true }

  delegate :name, :tagline, :description, :food_pairing, :abv, to: :data

  def data=(data)
    self.external_id = data["id"]
    super
  end

  def food_pairing
    # TODO: remove this when this is "correctly" done with StoreModel
    JSON.parse(data["food_pairing"] || "[]")
  end
end
