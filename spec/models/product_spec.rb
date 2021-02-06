# frozen_string_literal: true

RSpec.describe Product, type: :model do
  subject { build(:product) }

  describe "validations" do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:contentful_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:restaurant_contentful_id) }
  end
end
