# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    contentful_id { Faker::Alphanumeric.alpha }
    user_id { Faker::Alphanumeric.alpha }
  end
end
