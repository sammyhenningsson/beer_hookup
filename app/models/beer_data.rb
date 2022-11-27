# frozen_string_literal: true

class BeerData
  include StoreModel::Model

#   class Food
#     include StoreModel::Model
#     attribute :
#   end

  attribute :name, :string
  attribute :tagline, :string
  attribute :description, :string
  attribute :abv, :float
  attribute :food_pairing, :string # FIXME: How to store an array of strings using StoreModel?

  validates :name, :tagline, :description, :abv, :food_pairing, presence: true
end
