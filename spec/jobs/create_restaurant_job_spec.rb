# frozen_string_literal: true

RSpec.describe CreateRestaurantJob, type: :job do
  let(:entry) { build(:contentful_entry) }
  let(:user_id) { Faker::Alphanumeric.alpha }

  subject(:perform) do
    described_class.perform_now(
      user_id: user_id,
      access_token: "",
      space_id: "",
      name: ""
    )
  end

  before(:each) do
    allow_any_instance_of(ContentfulManagement).to receive(:create_restaurant).and_return(entry)
    ActiveJob::Base.queue_adapter = :test
  end

  it "should create new restaurant" do
    expect { perform }.to change { Restaurant.count }.by(1)
    expect(Restaurant.last.user_id).to eq(user_id)
    expect(Restaurant.last.contentful_id).to eq(entry.id)
  end

  describe "error" do
    let(:restaurant) { create(:restaurant) }
    let(:user_id) { restaurant.user_id }

    it "should raise error when Restaurant already exists" do
      expect { perform }.to raise_error(RuntimeError)
    end
  end
end
