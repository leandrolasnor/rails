# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name:                   'Teste',
  email:                  'teste@teste.com',
  password:               '123456',
  password_confirmation:  '123456',
  role:                   0
)

User.create!(
  name:                   'Other Teste',
  email:                  'otherteste@teste.com',
  password:               '123456',
  password_confirmation:  '123456',
  role:                   1
)

30.times{ 
  Album.create!(
    name: Faker::Games::Pokemon.name,
    year: rand(1948..Time.zone.now.year).to_i,
    artist_id: [1, 2, 3, 4, 5].sample
  )
}
