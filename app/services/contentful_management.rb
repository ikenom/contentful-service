# frozen_string_literal: true

class ContentfulManagement
  attr_reader :client

  def initialize(access_token:)
    @client = Contentful::Management::Client.new(access_token)
  end

  def create_restaurant(space_id:, name:, environment: "master")
    environment = client.environments(space_id).find(environment)
    restaurant_content = environment.content_types.find("restaurant")
    restaurant_entry = restaurant_content.entries.create(name: name)
    restaurant_entry.publish
    restaurant_entry
  end
end
