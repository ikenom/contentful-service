# frozen_string_literal: true

require "active_support/concern"

module ContentfulClient
  extend ActiveSupport::Concern

  included do
    private

    def contentful_client
      @contentful_client ||= Contentful::Client.new(
        access_token: ENV["CONTENTFUL_ACCESS_TOKEN"],
        space: ENV["CONTENTFUL_SPACE_ID"],
        dynamic_entries: :auto,
        raise_errors: true
      )
    end
  end
end
