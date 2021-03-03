# frozen_string_literal: true

class CreateRestaurantConsumer
  include Hutch::Consumer

  consume "cms.vendor.create"
  queue_name "consumer_contentful_service_create_restaurant"

  def process(message)
    CreateRestaurantJob.perform_later(
      sender_id: message[:sender_id],
      restaurant_name: message[:name],
      space_name: InitContentfulSpaceJob::SPACE_NAME
    )
  end
end
