# frozen_string_literal: true

FactoryBot.define do
  factory :nexoos_user, class: 'Nexoos::User' do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { Faker::Cannabis.medical_use }
    password_confirmation { password }
    role { User.roles[:user] }

    trait :admin do
      before(:create) do |user|
        user.role = User.roles[:admin]
      end
    end
  end
end
