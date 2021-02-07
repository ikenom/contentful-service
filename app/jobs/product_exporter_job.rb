# frozen_string_literal: true

class ProductExporterJob < ApplicationJob
  queue_as :default

  def perform(action:, contentful_id:)
    Hutch.connect

    case action
    when :add, :update
      upsert(action: action, contentful_id: contentful_id)
    when :delete
      delete(contentful_id: contentful_id)
    end
  end

  private

  def upsert(action:, contentful_id:)
    product = Product.find_by(contentful_id: contentful_id)
    owner = Restaurant.find_by(contentful_id: product.restaurant_contentful_id)
    routing_key = routing_key(action: action)
    Hutch.publish(
      routing_key,
      product_id: product.contentful_id,
      product_type: product._type,
      product: {
        name: product.name,
        price: product.price,
        owner_id: owner.ecommerce_id
      }
    )
  end

  def delete(contentful_id:)
    routing_key = routing_key(action: :delete)
    Hutch.publish(
      routing_key,
      product_id: contentful_id
    )
  end

  def routing_key(action:)
    case action
    when :add
      "cms.product.added"
    when :update
      "cms.product.updated"
    when :delete
      "cms.product.deleted"
    end
  end
end
