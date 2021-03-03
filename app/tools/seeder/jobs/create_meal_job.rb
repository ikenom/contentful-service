# frozen_string_literal: true

module Seeder
  module Jobs
    class CreateMealJob < ApplicationJob
      queue_as :contentful_service_create_meal

      def perform(space_name:, meal_name:, price:, restaurant_entry_id:, ingredient_entry_ids:)
        contentful_entry_service = ContentfulEntryService.new(access_token: ENV["CONTENTFUL_MANAGEMENT_ACCESS_TOKEN"])
        environment = contentful_entry_service.environment(space_name: space_name, environment_name: "master")
        contentful_entry_service.create_meal(
          name: meal_name,
          price: price,
          restaurant_entry_id: restaurant_entry_id,
          ingredient_entry_ids: ingredient_entry_ids,
          environment: environment
        )
      end
    end
  end
end
