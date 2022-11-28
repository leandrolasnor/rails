# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Moat::Album.destroy_all
Latech::Search::Address.destroy_all
Latech::Search::Address.clear_index!
Rails.cache.clear

user1 = User.create!(name: 'Teste', email: 'teste@teste.com', password: '123456', password_confirmation: '123456', role: 0)

user2 = User.create!(name: 'Other Teste', email: 'otherteste@teste.com', password: '123456', password_confirmation: '123456', role: 1)

30.times do
  Moat::Album.create!(
    name: Faker::Music.album,
    year: rand(1948..Time.zone.now.year).to_i,
    artist_id: rand(1..5)
  )
end

20.times do
  Latech::Search::Address.create! do |a|
    a.address = Faker::Address.street_address
    a.district = Faker::Name.middle_name
    a.city = Faker::Address.city
    a.state = Faker::Address.state_abbr
    a.zip = Faker::Number.number(digits: 8)
    a.address_assignments << Latech::AddressAssignment.new { |o| o.user_id = [user1.id, user2.id].sample }
  end
end
