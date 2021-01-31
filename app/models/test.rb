# frozen_string_literal: true

class Test
  include Mongoid::Document

  field :name, type: String
end

class Ingredient
  field :contentful_id, type: String
  field :price

  has_many :meals, inverse_of: :ingredients, class_name: "Meal"
end

class Meal
  field :price
  field :contentful_id

  has_many :ingredients, class_name: "Ingredient", inverse_of: :meals
end