# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    contentful_id { Faker::Alphanumeric.alpha }
    ecommerce_id { Faker::Alphanumeric.alpha }
  end
end
