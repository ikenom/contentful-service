# frozen_string_literal: true

class InitContentfulSpaceJob < ApplicationJob
  queue_as :contentful_service_init_contentful_space

  SPACE_NAME = "fytr"

  def perform
    client = ContentfulContentTypeService.new(access_token: ENV["CONTENTFUL_MANAGEMENT_ACCESS_TOKEN"])
    content_types = []

    space = client.create_space(name: SPACE_NAME, org_id: ENV["CONTENTFUL_ORG_ID"])
    environment = space.environments.find("master")

    content_types << client.create_restaurant_content_type(environment: environment)
    content_types << client.create_ingredient_content_type(environment: environment)
    content_types << client.create_prepped_ingredient_content_type(environment: environment)
    content_types << client.create_meal_content_type(environment: environment)

    content_types << ingredients(client: client, environment: environment)
    content_types << prepped_ingredients(client: client, environment: environment)
    content_types << meals(client: client, environment: environment)

    publish_content_types(content_types: content_types)
  end

  private

  def publish_content_types(content_types:)
    content_types.each(&:activate)
    content_types.each(&:publish)
  end

  def ingredients(client:, environment:)
    client.create_category_content_type(
      environment: environment,
      name: "Ingredients",
      id: ContentfulContentTypeService::INGREDIENTS_ID,
      validation_id: ContentfulContentTypeService::INGREDIENT_ID
    )
  end

  def prepped_ingredients(client:, environment:)
    client.create_category_content_type(
      environment: environment,
      name: "Prepped Ingredients",
      id: ContentfulContentTypeService::PREPPED_INGREDIENTS_ID,
      validation_id: ContentfulContentTypeService::PREPPED_INGREDIENT_ID
    )
  end

  def meals(client:, environment:)
    client.create_category_content_type(
      environment: environment,
      name: "Meals",
      id: ContentfulContentTypeService::MEALS_ID,
      validation_id: ContentfulContentTypeService::MEAL_ID
    )
  end
end
