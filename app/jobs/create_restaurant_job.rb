# frozen_string_literal: true

class CreateRestaurantJob < ApplicationJob
  queue_as :create_restaurant

  def perform(sender_id:, space_name:, restaurant_name:)
    raise "Restaurant with name: #{restaurant_name} already exists" if Restaurant.where(name: restaurant_name).exists?

    contentful_entry_service = ContentfulEntryService.new(access_token: ENV["CONTENTFUL_MANAGEMENT_ACCESS_TOKEN"])
    environment = contentful_entry_service.environment(space_name: space_name, environment_name: "master")
    restaurant_entry = contentful_entry_service.create_restaurant(environment: environment, name: restaurant_name)

    Restaurant.create!(contentful_id: restaurant_entry.id, name: restaurant_name)
  end
end
