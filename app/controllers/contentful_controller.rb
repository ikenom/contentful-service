# frozen_string_literal: true

class ContentfulController < ApplicationController
  def execute
    body = JSON.parse(request.body.read)

    case request.headers["X-Contentful-Topic"]
    when "ContentManagement.Entry.publish"
      publish(payload: body)
    when "ContentManagement.Entry.delete"
      delete(payload: body)
    end

    head :ok
  end

  private

  def publish(payload:)
    contentful_id = payload["sys"]["id"]
    content_type = payload["sys"]["contentType"]["sys"]["id"]
    ProductSyncJob.perform_later(contentful_id: contentful_id, content_type: content_type)
  end

  def delete(payload:)
    content_type = payload["sys"]["contentType"]["sys"]["id"]
    ProductDeleteSyncJob.perform_later(content_type: content_type)
  end
end
