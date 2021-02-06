# frozen_string_literal: true

RSpec.describe ContentfulManagement, :vcr do
  let(:access_token) { ENV["CONTENTFUL_MANAGEMENT_ACCESS_TOKEN"] }
  let(:space_id) { ENV["CONTENTFUL_SPACE_ID"] }

  subject(:contentful_service) { described_class.new(access_token: access_token) }

  describe "#create_restaurant" do
    it "should create new restaurant" do
      entry = contentful_service.create_restaurant(space_id: space_id, name: "Test")
      expect(entry.published?).to be_truthy
    end
  end
end
