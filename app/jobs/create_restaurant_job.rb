# frozen_string_literal: true

class CreateRestaurantJob < ApplicationJob
  queue_as :default

  def perform(ecommerce_id:, access_token:, space_id:, name:)
    raise "Restaurant with ecommerce id: #{ecommerce_id} already exists" if Restaurant.where(ecommerce_id: ecommerce_id).exists?

    contentful_management_service = ContentfulManagement.new(access_token: access_token)
    restaurant_entry = contentful_management_service.create_restaurant(space_id: space_id, name: name)

    Restaurant.create!(ecommerce_id: ecommerce_id, contentful_id: restaurant_entry.id)
  end
end
