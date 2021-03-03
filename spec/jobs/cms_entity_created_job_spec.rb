# frozen_string_literal: true

RSpec.describe CmsEntityCreatedJob, :vcr, type: :job do
  let(:cms_id) { Faker::Alphanumeric.alpha }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should update Meal types" do
    meal = create(:meal)
    described_class.perform_now(cms_id: cms_id, type: "Meal", entity_id: meal.id.to_s)
  end

  it "should update Restaurant types" do
    meal = create(:restaurant)
    described_class.perform_now(cms_id: cms_id, type: "Restaurant", entity_id: meal.id.to_s)
  end

  it "should update Ingredient types" do
    ingredient = create(:ingredient)
    described_class.perform_now(cms_id: cms_id, type: "Ingredient", entity_id: ingredient.id.to_s)
  end

  it "should update Prepped Ingredient types" do
    prepped_ingredient = create(:prepped_ingredient)
    described_class.perform_now(cms_id: cms_id, type: "PreppedIngredient", entity_id: prepped_ingredient.id.to_s)
  end
end
