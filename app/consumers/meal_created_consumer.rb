# frozen_string_literal: true

class MealCreatedConsumer
  include Hutch::Consumer
  consume "contentful.meal.created"

  def process(message)
    CmsEntityCreatedJob.perform_later(
      entity_id: message[:sender_id],
      cms_id: message[:cms_id],
      type: Meal.to_s
    )
  end
end
