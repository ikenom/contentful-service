# frozen_string_literal: true

RSpec.describe SynchronizerJob, :vcr, type: :job do
  let(:contentful_product) { create(:product, id: "id") }
  subject(:perform) { described_class.perform_now }

  before(:each) do
    allow_any_instance_of(Contentful::Client).to receive(:entries).and_return([contentful_product])
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue product sync jobs" do
    perform

    expect(ProductSyncJob).to have_been_enqueued.exactly(2)
  end
end
