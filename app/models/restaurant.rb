# frozen_string_literal: true

class Restaurant
  include Mongoid::Document

  field :contentful_id, type: String
  field :user_id, type: String

  validates :contentful_id, :user_id, presence: true
end
