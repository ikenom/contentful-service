# frozen_string_literal: true

class SynchronizerJob < ApplicationJob
  include ContentfulClient

  queue_as :default

  def perform
    ingredients_sync
    meals_sync
  end

  private

  def ingredients_sync
    content_type = "ingredient"
    contentful_client.entries(content_type: content_type, include: 2).each do |ingredient|
      ProductSyncJob.perform_later(contentful_id: ingredient.id, content_type: content_type)
    end
  end

  def meals_sync
    content_type = "meal"
    contentful_client.entries(content_type: content_type, include: 2).each do |meal|
      ProductSyncJob.perform_later(contentful_id: meal.id, content_type: content_type)
    end
  end
end
