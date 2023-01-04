# frozen_string_literal: true

FactoryBot.define do
  factory :loan, class: 'Nexoos::Loan' do
    pv { Faker::Number.number(digits: 5) }
    nper { rand(32..48) }
    rate { rand(1..5) }
  end
end
