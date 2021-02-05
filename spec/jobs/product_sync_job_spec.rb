# frozen_string_literal: true

RSpec.describe ProductSyncJob, type: :job do
  let(:content_type) { "meal" }
  let(:contentful_id) { 1 }

  let(:contentful_product) { create(:product) }
  subject(:perform) { described_class.perform_now(contentful_id: contentful_id, content_type: content_type) }

  before(:each) do
    allow_any_instance_of(Contentful::Client).to receive(:entries).and_return([contentful_product])
    allow(ProductExporterJob).to receive(:perform_later)
  end

  describe "new product" do
    it "should create new product" do
      expect { perform }.to change { Product.count }.by(1)
    end
  end

  describe "update product" do
    let(:product) { create(:meal) }
    let(:contentful_id) { product.contentful_id }

    it "should update current product" do
      perform
      expect(Product.last.name).to eq(contentful_product.name)
      expect(Product.last.price).to eq(contentful_product.price)
    end
  end

  describe "do not update product" do
    let(:product) { create(:meal) }
    let(:contentful_product) { product }
    let(:contentful_id) { product.contentful_id }

    it "should not update current product if no changes" do
      perform
      expect(Product.last.name).to eq(contentful_product.name)
      expect(Product.last.price).to eq(contentful_product.price)
    end
  end
end
