# frozen_string_literal: true

RSpec.describe RestaurantCreatedJob, type: :job do
  let(:restaurant) { create(:restaurant) }
  let(:sender_id) { Faker::Alphanumeric.alpha }

  subject(:perform) { described_class.perform_now(sender_id: sender_id, contentful_id: restaurant.contentful_id) }

  before(:each) do
    allow(Hutch).to receive(:connect)
    allow(Hutch).to receive(:publish)
  end

  it "should publish successfully" do
    expect(Hutch).to receive(:publish).with(
      "cms.vendor.created",
      sender_id: sender_id,
      cms_id: restaurant.contentful_id
    )

    perform
  end
end
