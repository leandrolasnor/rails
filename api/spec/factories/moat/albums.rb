FactoryBot.define do
  factory :album do
    name { Faker::Games::Pokemon.name }
    year { rand(1948..Time.now.year) }
    artist_id { [1,2,3,4,5].sample }
  end
end