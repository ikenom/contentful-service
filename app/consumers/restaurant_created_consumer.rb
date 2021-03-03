# frozen_string_literal: true

class RestaurantCreatedConsumer
  include Hutch::Consumer
  consume "contentful.restaurant.created"

  def process(message)
    CmsEntityCreatedJob.perform_later(
      entity_id: message[:sender_id],
      cms_id: message[:cms_id],
      type: Restaurant.to_s
    )
  end
end
