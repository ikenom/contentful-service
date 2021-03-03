# frozen_string_literal: true

class Restaurant
  include Mongoid::Document

  field :contentful_id, type: String

  field :name, type: String
  index({ name: 1 }, { unique: true })

  validates :contentful_id, :name, presence: true
end
