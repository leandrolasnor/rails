# frozen_string_literal: true

FactoryBot.define do
  factory :address_assignment, class: 'Latech::AddressAssignment' do
    address
    user
  end
end
