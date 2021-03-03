# frozen_string_literal: true

RSpec.describe PreppedIngredientCreatedConsumer do
  let(:message) do
    {
      sender_id: Faker::Alphanumeric.alpha,
      cms_id: Faker::Alphanumeric.alpha,
    }
  end
  subject(:consumer) { described_class.new }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue cms created job" do
    consumer.process(message)
    expect(CmsEntityCreatedJob).to have_been_enqueued.with({
      entity_id: message[:sender_id],
      cms_id: message[:cms_id],
      type: PreppedIngredient.to_s,
                                                                          })
  end
end
