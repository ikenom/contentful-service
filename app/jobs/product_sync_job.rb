# frozen_string_literal: true

class ProductSyncJob < ApplicationJob
  include ContentfulClient

  queue_as :default

  def perform(contentful_id:, content_type:)
    contentful_product = contentful_client.entries(:content_type => content_type, :include => 2, "sys.id" => contentful_id).first
    product_type =
      case content_type
      when "meal" then Meal
      when "ingredient" then Ingredient
      end
    product = product_type.where(contentful_id: contentful_id).first

    if product.nil?
      product = product_type.create!(contentful_id: contentful_id, price: contentful_product.price, name: contentful_product.name, restaurant_contentful_id: contentful_product.owner.id)
      ProductExporterJob.perform_later(action: :add, product_id: product.id.to_s)
    else
      return unless product_changed?(product: product, contentful_product: contentful_product)

      product.name = contentful_product.name
      product.price = contentful_product.price
      product.restaurant_contentful_id = contentful_product.owner.id
      product.save!

      ProductExporterJob.perform_later(action: :update, product_id: product.id.to_s)
    end
  end

  private

  def product_changed?(product:, contentful_product:)
    product.name != contentful_product.name ||
    product.price != contentful_product.price ||
    product.restaurant_contentful_id != contentful_product.owner.id
  end
end
