require "active_support/concern"

module ContentfulModel
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document

    field :content_type_id, type: String
    field :contentful_id, type: String

    def content
      client.entries(content_type: content_type_id, include: 2, "sys.id" => contentful_id).first
    end

    private

    def client
      @client ||= Contentful::Client.new(
        access_token: ENV["CONTENTFUL_ACCESS_TOKEN"],
        space: ENV["CONTENTFUL_SPACE_ID"],
        dynamic_entries: :auto,
        raise_errors: true
      )
    end
  end
end