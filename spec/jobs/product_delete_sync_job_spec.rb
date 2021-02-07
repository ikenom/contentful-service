# frozen_string_literal: true

RSpec.describe ProductDeleteSyncJob, :vcr, type: :job do
  let(:content_type) { "meal" }
  let(:contentful_id) { "2bZYaQ1EZmt0eUteLZbUfy" }
  let(:client) do
    Contentful::Client.new(
      access_token: ENV["CONTENTFUL_ACCESS_TOKEN"],
      space: ENV["CONTENTFUL_SPACE_ID"],
      dynamic_entries: :auto,
      raise_errors: true
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should delete products not found in contentful" do
    create(:meal, contentful_id: contentful_id)
    create(:meal)

    expect { described_class.perform_now(content_type: content_type) }.to change { Product.count }.by(-1)
  end

  it "should delete products not found in contentful" do
    create(:meal, contentful_id: contentful_id)
    create(:meal)

    expect { described_class.perform_now(content_type: content_type) }.to change { Product.count }.by(-1)
  end

  it "should broadcast deletion" do
    create(:meal, contentful_id: contentful_id)
    create(:meal)

    described_class.perform_now(content_type: content_type)
    expect(ProductExporterJob).to have_been_enqueued
  end

  it "should not broadcast deletion if nothing was deleted" do
    create(:meal, contentful_id: contentful_id)

    described_class.perform_now(content_type: content_type)
    expect(ProductExporterJob).to_not have_been_enqueued
  end

  it "should not broadcast deletion if restaurant" do
    create(:restaurant)

    described_class.perform_now(content_type: "restaurant")
    expect(ProductExporterJob).to_not have_been_enqueued
  end
end
