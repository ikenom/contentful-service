# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    contentful_id { Faker::Alphanumeric.alpha }
    name { Faker::Name.name }
  end
end
