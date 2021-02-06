# frozen_string_literal: true

RSpec.describe ProductSyncJob, :vcr, type: :job do
  let(:content_type) { "meal" }
  let(:contentful_id) { "2bZYaQ1EZmt0eUteLZbUfy" }
  let(:client) { Contentful::Client.new(
    access_token: ENV["CONTENTFUL_ACCESS_TOKEN"],
    space: ENV["CONTENTFUL_SPACE_ID"],
    dynamic_entries: :auto,
    raise_errors: true
  )}
  let(:contentful_product) { client.entries(:content_type => content_type, :include => 2, "sys.id" => contentful_id).first }

  subject(:perform) { described_class.perform_now(contentful_id: contentful_id, content_type: content_type) }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  describe "new product" do
    it "should create new product" do
      expect { perform }.to change { Product.count }.by(1)
      expect(ProductExporterJob).to have_been_enqueued
    end
  end

  describe "update product" do
    it "should update current product" do
      product = create(:meal, contentful_id: contentful_id)
      perform
      product = product.reload

      expect(product.name).to eq(contentful_product.name)
      expect(product.price).to eq(contentful_product.price)
      expect(product.restaurant_contentful_id).to eq(contentful_product.owner.id)

      expect(ProductExporterJob).to have_been_enqueued
    end

    it "should not update current product if no changes" do
      create(:meal,
        contentful_id: contentful_id,
        name: contentful_product.name,
        price: contentful_product.price,
        restaurant_contentful_id: contentful_product.owner.id)

      perform
      expect(ProductExporterJob).not_to have_been_enqueued
    end
  end
end
