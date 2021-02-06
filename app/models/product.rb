# frozen_string_literal: true

class Product
  include Mongoid::Document

  field :contentful_id, type: String
  field :name, type: String
  field :price, type: Float
  field :restaurant_contentful_id, type: String

  validates :contentful_id, :name, :price, :restaurant_contentful_id, presence: true
end
