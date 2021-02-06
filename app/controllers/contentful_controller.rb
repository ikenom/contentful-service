# frozen_string_literal: true

class ContentfulController < ApplicationController
  def execute
    body = JSON.parse(request.body.read)

    case request.headers["X-Contentful-Topic"]
    when "ContentManagement.Entry.publish"
      publish(body)
    end

    render "ok"
  end

  private

  def publish(body)
    contentful_id = body["sys"]["id"]
    content_type = body["sys"]["contentType"]["sys"]["id"]
    ProductSyncJob.perform_later(contentful_id: contentful_id, content_type: content_type)
  end
end
