# frozen_string_literal: true

RSpec.describe Restaurant, type: :model do
  subject { build(:restaurant) }

  describe "validations" do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:contentful_id) }
    it { is_expected.to validate_presence_of(:ecommerce_id) }
  end
end
