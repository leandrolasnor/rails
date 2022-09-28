# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: 'Latech::Search::Address' do
    address { Faker::Address.street_address }
    district { Faker::Name.middle_name }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Number.number(digits: 8) }
    users { [create(:user)] }

    trait :belongs_to_admin_user do
      before(:create) do |address|
        address.users << create(:user, :admin)
      end
    end
  end
end
