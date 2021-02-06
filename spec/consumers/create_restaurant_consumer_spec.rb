# frozen_string_literal: true

RSpec.describe CreateRestaurantConsumer do
  let(:message) do
    {
      ecommerce_id: Faker::Alphanumeric.alpha,
      name: Faker::Alphanumeric.alpha
    }
  end
  subject(:consumer) { described_class.new }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue create restaurant jobs" do
    consumer.process(message)
    expect(CreateRestaurantJob).to have_been_enqueued.with(hash_including({
                                                                            ecommerce_id: message[:ecommerce_id],
                                                                            name: message[:name],
                                                                          }))
  end
end
