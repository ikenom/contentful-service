# frozen_string_literal: true

class ProductSyncJob < ApplicationJob
  include ContentfulClient

  queue_as :contentful_service_product_sync

  def perform(contentful_id:, content_type:)
    contentful_product = contentful_client.entries(:content_type => content_type, :include => 2, "sys.id" => contentful_id).first
    product_type =
      case content_type
      when "meal" then Meal
      when "ingredient" then Ingredient
      when "prepped_ingredient" then PreppedIngredient
      end
    product = product_type.where(contentful_id: contentful_id).first

    if product.nil?
      product = product_type.create!(contentful_id: contentful_id, price: contentful_product.price, name: contentful_product.name, restaurant_contentful_id: contentful_product.restaurant.id)
      ProductExporterJob.perform_later(action: :add, contentful_id: product.contentful_id)
    else
      return unless product_changed?(product: product, contentful_product: contentful_product)

      product.name = contentful_product.name
      product.price = contentful_product.price
      product.restaurant_contentful_id = contentful_product.restaurant.id
      product.save!

      ProductExporterJob.perform_later(action: :update, contentful_id: product.contentful_id)
    end
  end

  private

  def product_changed?(product:, contentful_product:)
    product.name != contentful_product.name ||
      product.price != contentful_product.price ||
      product.restaurant_contentful_id != contentful_product.restaurant.id
  end
end
