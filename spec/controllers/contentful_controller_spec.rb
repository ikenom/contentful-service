# frozen_string_literal: true

RSpec.describe ContentfulController, type: :request do
  let(:contentful_id) { Faker::Alphanumeric.alpha }
  let(:content_type) { Faker::Alphanumeric.alpha }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should queue product sync job when new content published" do
    headers = { "X-Contentful-Topic" => "ContentManagement.Entry.publish" }
    payload = {
      sys: {
        id: contentful_id,
        contentType: {
          sys: {
            id: content_type
          }
        }
      }
    }

    post "/", params: payload.to_json, headers: headers

    expect(ProductSyncJob).to have_been_enqueued.with({ contentful_id: contentful_id, content_type: content_type })
    expect(response).to have_http_status(200)
  end
end
