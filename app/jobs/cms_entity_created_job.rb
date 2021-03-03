# frozen_string_literal: true

class CmsEntityCreatedJob < ApplicationJob
  queue_as :cms_entity_created

  def perform(entity_id:, cms_id:, type:)
    entity = type.constantize.find(entity_id)
    entity.update!(contentful_id: cms_id)
  end
end
