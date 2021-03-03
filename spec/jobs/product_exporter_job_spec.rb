# frozen_string_literal: true

RSpec.describe ProductExporterJob, type: :job do
  let(:restaurant) { create(:restaurant) }
  let(:product) { create(:meal, restaurant_contentful_id: restaurant.contentful_id) }

  subject(:exporter) { described_class }

  before(:each) do
    allow(Hutch).to receive(:connect)
  end

  it "should publish successfully for add" do
    expect(Hutch).to receive(:publish).with(
      "cms.product.created",
      cms_id: product.contentful_id,
      vendor_id: product.restaurant_contentful_id,
      name: product.name,
      price: product.price,
      type: product._type
    )

    action = :add
    exporter.perform_now(action: action, contentful_id: product.contentful_id)
  end

  it "should publish successfully for update" do
    expect(Hutch).to receive(:publish).with(
      "cms.product.updated",
      cms_id: product.contentful_id,
      vendor_id: product.restaurant_contentful_id,
      name: product.name,
      price: product.price,
      type: product._type
    )

    action = :update
    exporter.perform_now(action: action, contentful_id: product.contentful_id)
  end

  it "should publish successfully for delete" do
    expect(Hutch).to receive(:publish).with(
      "cms.product.deleted",
      product_id: product.contentful_id
    )

    action = :delete
    exporter.perform_now(action: action, contentful_id: product.contentful_id)
  end

  describe "#routing_key" do
    it "should use add queue" do
      expect(Hutch).to receive(:publish).with("cms.product.created", any_args)

      action = :add
      exporter.perform_now(action: action, contentful_id: product.contentful_id)
    end

    it "should use update queue" do
      expect(Hutch).to receive(:publish).with("cms.product.updated", any_args)

      action = :update
      exporter.perform_now(action: action, contentful_id: product.contentful_id)
    end

    it "should use delete queue" do
      expect(Hutch).to receive(:publish).with("cms.product.deleted", any_args)

      action = :delete
      exporter.perform_now(action: action, contentful_id: product.contentful_id)
    end
  end
end
