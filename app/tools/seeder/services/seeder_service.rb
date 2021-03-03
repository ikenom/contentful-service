# frozen_string_literal: true

require "set"

module Seeder
  module Services
    class SeederService
      def create_ingredient(restaurant_entry_id:)
        seed = 42
        random = Random.new(seed)
        Faker::Config.random = random

        ingredient_names = ingredient_names(count: 10)
        prepped_ingredient_names = prepped_ingredient_names(count: 5)
        meal_names = meal_names(count: 5)
        space_name = ::InitContentfulSpaceJob::SPACE_NAME

        ingredient_entries = []
        prepped_ingredient_entries = []

        ingredient_names.each do |name|
          price = Faker::Commerce.price(range: 0.01..3.0, as_string: true).to_f
          ingredient_entries << Seeder::Jobs::CreateIngredientJob.perform_now(
            space_name: space_name,
            ingredient_name: name,
            price: price,
            restaurant_entry_id: restaurant_entry_id
          )
        end

        prepped_ingredient_names.each_with_index do |name, index|
          random = Random.new(seed + index)
          price = Faker::Commerce.price(range: 0.01..3.0, as_string: true).to_f
          prepped_ingredient_entries << Seeder::Jobs::CreatePreppedIngredientJob.perform_now(
            space_name: space_name,
            prepped_ingredient_name: name,
            price: price,
            restaurant_entry_id: restaurant_entry_id,
            ingredient_entry_ids: ingredient_entries.sample(random.rand(2..5), random: random).map(&:id)
          )
        end

        meal_names.each_with_index do |name, index|
          random = Random.new(seed + index)
          price = Faker::Commerce.price(range: 0.01..3.0, as_string: true).to_f
          entries = []
          entries.concat(ingredient_entries)
          entries.concat(prepped_ingredient_entries)

          Seeder::Jobs::CreateMealJob.perform_now(
            space_name: space_name,
            meal_name: name,
            price: price,
            restaurant_entry_id: restaurant_entry_id,
            ingredient_entry_ids: entries.sample(random.rand(7..10), random: random).map(&:id)
          )
        end
      end

      private

      def ingredient_names(count:)
        set = Set.new
        set.add(Faker::Food.ingredient) while set.count < count
        set
      end

      def prepped_ingredient_names(count:)
        set = Set.new
        set.add(Faker::Food.spice) while set.count < count
        set
      end

      def meal_names(count:)
        set = Set.new
        set.add(Faker::Food.dish) while set.count < count
        set
      end
    end
  end
end
