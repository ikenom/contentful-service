# frozen_string_literal: true

class ProductExporterJob < ApplicationJob
  queue_as :default

  def perform(action:, product_id:)
    Hutch.connect

    product = Product.find(product_id)
    routing_key = routing_key(action: action)
    Hutch.publish(
      routing_key,
      product_id: product.contentful_id,
      product_type: product._type,
      product: {
        name: product.name,
        price: product.price
      }
    )
  end

  private

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
