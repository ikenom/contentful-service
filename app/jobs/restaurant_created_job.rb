# frozen_string_literal: true

class RestaurantCreatedJob < ApplicationJob
  queue_as :restaurant_created

  def perform(sender_id:, contentful_id:)
    Hutch.connect
    Hutch.publish("cms.vendor.created", {
                    sender_id: sender_id,
                    cms_id: contentful_id
                  })
  end
end
