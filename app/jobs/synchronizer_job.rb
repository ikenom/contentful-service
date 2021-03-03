# frozen_string_literal: true

class SynchronizerJob < ApplicationJob
  include ContentfulClient

  queue_as :contentful_service_synchronizer

  def perform
    ingredients_sync
    meals_sync
    prepped_ingredients_sync
    delete_sync
  end

  private

  def ingredients_sync
    content_type = "ingredient"
    contentful_client.entries(content_type: content_type, include: 2).each do |ingredient|
      ProductSyncJob.perform_later(contentful_id: ingredient.id, content_type: content_type)
    end
  end

  def prepped_ingredients_sync
    content_type = "prepped_ingredient"
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

  def delete_sync
    ProductDeleteSyncJob.perform_later(content_type: "ingredient")
    ProductDeleteSyncJob.perform_later(content_type: "meal")
    ProductDeleteSyncJob.perform_later(content_type: "restaurant")
    ProductDeleteSyncJob.perform_later(content_type: "prepped_ingredient")
  end
end
