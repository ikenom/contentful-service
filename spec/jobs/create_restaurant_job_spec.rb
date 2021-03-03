# frozen_string_literal: true

RSpec.describe CreateRestaurantJob, type: :job do
  let(:entry) { build(:contentful_entry) }
  let(:sender_id) { Faker::Alphanumeric.alpha }
  let(:space_name) { Faker::Alphanumeric.alpha }
  let(:name) { Faker::Restaurant.name }

  subject(:perform) do
    described_class.perform_now(
      sender_id: sender_id,
      space_name: space_name,
      restaurant_name: name
    )
  end

  before(:each) do
    allow_any_instance_of(ContentfulEntryService).to receive(:create_restaurant).and_return(entry)
    allow_any_instance_of(ContentfulEntryService).to receive(:environment)
    ActiveJob::Base.queue_adapter = :test
  end

  it "should create new restaurant" do
    expect { perform }.to change { Restaurant.count }.by(1)
    expect(Restaurant.last.name).to eq(name)
    expect(Restaurant.last.contentful_id).to eq(entry.id)
  end

  it "should enqueue Restaurant Created Job" do
    perform
    expect(RestaurantCreatedJob).to have_been_enqueued
  end

  describe "error" do
    let(:restaurant) { create(:restaurant) }
    let(:name) { restaurant.name }

    it "should raise error when Restaurant already exists" do
      expect { perform }.to raise_error(RuntimeError)
    end
  end
end
