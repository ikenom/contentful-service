# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Alphanumeric.alpha }
    price { Faker::Commerce.price }
    contentful_id { Faker::Alphanumeric.alpha }
  end
end
