# frozen_string_literal: true

class ProductDeleteSyncJob < ApplicationJob
  include ContentfulClient

  queue_as :default

  def perform(content_type:)
    product_type =
      case content_type
      when "meal" then Meal
      when "ingredient" then Ingredient
      end

    contentful_products_ids = contentful_client.entries(content_type: content_type).map(&:id)
    current_product_ids = product_type.all.map(&:contentful_id)
    exclusion_ids = current_product_ids - contentful_products_ids
    exclusion_ids.each do |id|
      product = product_type.find_by(contentful_id: id)
      ProductExporterJob.perform_now(action: :delete, product_id: product.id.to_s)
      product.delete
    end
  end
end
