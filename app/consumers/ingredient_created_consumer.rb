# frozen_string_literal: true

class IngredientCreatedConsumer
  include Hutch::Consumer
  consume "contentful.ingredient.created"

  def process(message)
    CmsEntityCreatedJob.perform_later(
      entity_id: message[:sender_id],
      cms_id: message[:cms_id],
      type: Ingredient.to_s
    )
  end
end
