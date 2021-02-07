# frozen_string_literal: true

class ProductExporterJob < ApplicationJob
  queue_as :default

  def perform(action:, product_id:)
    Hutch.connect

    case action
    when :add, :update
      upsert(action: action, product_id: product_id)
    when :delete
      delete(product_id: product_id)
    end
  end

  private

  def upsert(action:, product_id:)
    product = Product.find(product_id)
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

  def delete(product_id:)
    product = Product.find(product_id)
    routing_key = routing_key(action: :delete)
    Hutch.publish(
      routing_key,
      product_id: product.contentful_id
    )
  end

  def routing_key(action:)
    case action
    when :add
      "ecommerce.product.add"
    when :update
      "ecommerce.product.update"
    when :delete
      "ecommerce.product.delete"
    end
  end
end
