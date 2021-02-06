# frozen_string_literal: true

class Restaurant
  include Mongoid::Document

  field :contentful_id, type: String
  field :ecommerce_id, type: String

  validates :contentful_id, :ecommerce_id, presence: true
end
