# frozen_string_literal: true

class PreppedIngredientCreatedConsumer
  include Hutch::Consumer
  consume "contentful.prepped_ingredient.created"

  def process(message)
    CmsEntityCreatedJob.perform_later(
      entity_id: message[:sender_id],
      cms_id: message[:cms_id],
      type: PreppedIngredient.to_s
    )
  end
end
