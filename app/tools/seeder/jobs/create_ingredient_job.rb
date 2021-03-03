# frozen_string_literal: true

module Seeder
  module Jobs
    class CreateIngredientJob < ApplicationJob
      queue_as :create_ingredient

      retry_on Contentful::Management::RateLimitExceeded

      def perform(space_name:, ingredient_name:, price:, restaurant_entry_id:)
        contentful_entry_service = ContentfulEntryService.new(access_token: ENV["CONTENTFUL_MANAGEMENT_ACCESS_TOKEN"])
        environment = contentful_entry_service.environment(space_name: space_name, environment_name: "master")
        contentful_entry_service.create_ingredient(
          name: ingredient_name,
          price: price,
          restaurant_entry_id: restaurant_entry_id,
          environment: environment)
      end
    end
  end
end
