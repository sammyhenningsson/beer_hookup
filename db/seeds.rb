# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#

fixture_file = File.expand_path("../spec/fixtures/files/beers.json", __dir__)
data = JSON.parse(File.read(fixture_file))
data.each do |beer|
  Beer.create_with(data: beer)
    .create_or_find_by(external_id: beer["id"])
end
