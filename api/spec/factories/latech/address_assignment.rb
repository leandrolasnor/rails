# frozen_string_literal: true

FactoryBot.define do
  factory :address_assignment, class: 'Latech::AddressAssignment' do
    address { nil }
    user { nil }
  end
end
