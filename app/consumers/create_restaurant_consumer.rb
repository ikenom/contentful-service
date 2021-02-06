# frozen_string_literal: true

class CreateRestaurantConsumer
  include Hutch::Consumer
  consume "cms.restaurant.create"

  def process(message)
    CreateRestaurantJob.perform_later(
      ecommerce_id: message[:ecommerce_id],
      name: message[:name],
      access_token: ENV["CONTENTFUL_MANAGEMENT_ACCESS_TOKEN"],
      space_id: ENV["CONTENTFUL_SPACE_ID"]
    )
  end
end
