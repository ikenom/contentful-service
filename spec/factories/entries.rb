# frozen_string_literal: true

class MockContentfulEntry
  attr_accessor :id
end

FactoryBot.define do
  factory :contentful_entry, class: MockContentfulEntry do
    id { Faker::Alphanumeric.alpha }
  end
end
