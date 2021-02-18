# frozen_string_literal: true

class CreateRestaurantJob < ApplicationJob
  queue_as :contentful_service_create_restaurant

  def perform(user_id:, access_token:, space_id:, name:)
    raise "Restaurant with user id: #{user_id} already exists" if Restaurant.where(user_id: user_id).exists?

    contentful_management_service = ContentfulManagement.new(access_token: access_token)
    restaurant_entry = contentful_management_service.create_restaurant(space_id: space_id, name: name)

    Restaurant.create!(user_id: user_id, contentful_id: restaurant_entry.id)
  end
end
