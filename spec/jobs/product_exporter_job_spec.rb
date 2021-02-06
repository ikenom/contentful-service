# frozen_string_literal: true

RSpec.describe ProductExporterJob, type: :job do
  let(:restaurant) { create(:restaurant) }
  let(:product) { create(:meal, restaurant_contentful_id: restaurant.contentful_id) }

  subject(:exporter) { described_class }

  before(:each) do
    allow(Hutch).to receive(:connect)
  end

  it "should publish successfully" do
    expect(Hutch).to receive(:publish).with(
      "ecommerce.product.add",
      product_id: product.contentful_id,
      product_type: product._type,
      product: {
        name: product.name,
        price: product.price,
        owner_id: restaurant.ecommerce_id
      }
    )

    action = :add
    exporter.perform_now(action: action, product_id: product.id.to_s)
  end

  describe "#routing_key" do
    it "should use add queue" do
      expect(Hutch).to receive(:publish).with("ecommerce.product.add", any_args)

      action = :add
      exporter.perform_now(action: action, product_id: product.id.to_s)
    end

    it "should use update queue" do
      expect(Hutch).to receive(:publish).with("ecommerce.product.update", any_args)

      action = :update
      exporter.perform_now(action: action, product_id: product.id.to_s)
    end

    it "should use delete queue" do
      expect(Hutch).to receive(:publish).with("ecommerce.product.delete", any_args)

      action = :delete
      exporter.perform_now(action: action, product_id: product.id.to_s)
    end
  end
end
