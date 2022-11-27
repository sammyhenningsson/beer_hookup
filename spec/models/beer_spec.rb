require "rails_helper"

RSpec.describe Beer, type: :model do
  let(:data) do
    JSON.parse(file_fixture("beers.json").read)
      .first
      .merge(
        "id" => 5,
        "name" => "Tasty lager",
        "tagline" => "The best beer in the world.",
        "description" => "Tastier that you would think.",
        "abv" => 5.2,
        "food_pairing" => [
          "pancakes",
          "porridge"
        ]
      )
  end

  it "assign values from data" do
    beer = Beer.new(data:)

    expect(beer).to be_valid
    expect(beer.external_id).to eq(5)
    expect(beer.name).to eq("Tasty lager")
    expect(beer.tagline).to eq("The best beer in the world.")
    expect(beer.description).to eq("Tastier that you would think.")
    expect(beer.abv).to eq(5.2)
    expect(beer.food_pairing).to eq(["pancakes", "porridge"])
  end
end
