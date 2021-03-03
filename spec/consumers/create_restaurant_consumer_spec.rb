# frozen_string_literal: true

RSpec.describe CreateRestaurantConsumer do
  let(:message) do
    {
      sender_id: Faker::Alphanumeric.alpha,
      name: Faker::Alphanumeric.alpha
    }
  end
  subject(:consumer) { described_class.new }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue create restaurant jobs" do
    consumer.process(message)
    expect(CreateRestaurantJob).to have_been_enqueued.with({
                                                                            sender_id: message[:sender_id],
                                                                            restaurant_name: message[:name],
                                                                            space_name: InitContentfulSpaceJob::SPACE_NAME,
                                                                          })
  end
end
