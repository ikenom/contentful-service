# frozen_string_literal: true

RSpec.describe Restaurant, type: :model do
  subject { build(:restaurant) }

  describe "validations" do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to be_valid }

    it { is_expected.to have_field(:name).of_type(String) }
    it { is_expected.to have_index_for(name: 1) }
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to have_field(:contentful_id).of_type(String) }
    it { is_expected.to validate_presence_of(:contentful_id) }
  end
end
