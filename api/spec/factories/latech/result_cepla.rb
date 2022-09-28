# frozen_string_literal: true

FactoryBot.define do
  factory :result_cepla, class: Hash do
    logradouro { Faker::Address.street_address }
    bairro { Faker::Name.middle_name }
    cidade { Faker::Address.city }
    uf { Faker::Address.state_abbr }

    initialize_with { attributes }
  end
end
