# frozen_string_literal: true

class Product
  include Mongoid::Document

  field :contentful_id, type: String
  field :name, type: String
  field :price, type: Float

  validates :contentful_id, :name, :price, presence: true
end
