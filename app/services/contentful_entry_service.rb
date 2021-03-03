# frozen_string_literal: true

class ContentfulEntryService
  attr_reader :client

  def initialize(access_token:)
    @client = Contentful::Management::Client.new(access_token, raise_errors: true)
  end

  def environment(space_name:, environment_name:)
    space = client.spaces.all.filter { |s| s.name == space_name }.first
    space.environments.find(environment_name)
  end

  def create_restaurant(environment:, name:)
    restaurant_content = environment.content_types.find(ContentfulContentTypeService::RESTAURANT_ID)
    ingredients_content = environment.content_types.find(ContentfulContentTypeService::INGREDIENTS_ID)
    prepped_ingredients_content = environment.content_types.find(ContentfulContentTypeService::PREPPED_INGREDIENTS_ID)
    meals_content = environment.content_types.find(ContentfulContentTypeService::MEALS_ID)

    ingredients_entry = ingredients_content.entries.create(name: "#{name} Ingredients")
    prepped_ingredients_entry = prepped_ingredients_content.entries.create(name: "#{name} Prepped Ingredients")
    meals_entry = meals_content.entries.create(name: "#{name} Meals")

    [ingredients_entry, prepped_ingredients_entry, meals_entry].each(&:publish)

    restaurant_entry = restaurant_content.entries.create(
      name: name,
      ingredients: ingredients_entry,
      prepped_ingredients: prepped_ingredients_entry,
      meals: meals_entry
    )

    restaurant_entry.publish
  end

  def create_ingredient(name:, price:, restaurant_entry_id:, environment:)
    ingredient_content = environment.content_types.find(ContentfulContentTypeService::INGREDIENT_ID)

    restaurant_entry = environment.entries.find(restaurant_entry_id)
    ingredients_entry = environment.entries.find(restaurant_entry.ingredients["sys"]["id"])

    ingredient_entry = ingredient_content.entries.create(name: name, price: price, restaurant: restaurant_entry)
    ingredient_entry.publish

    ingredients_entry.ingredients = [] if ingredients_entry.ingredients.nil?
    ingredients_entry.ingredients << ingredient_entry
    ingredients_entry.update(ingredients: ingredients_entry.ingredients)
    ingredients_entry.publish

    ingredient_entry
  end

  def create_prepped_ingredient(name:, price:, restaurant_entry_id:, environment:, ingredient_entry_ids:)
    prepped_ingredient_content = environment.content_types.find(ContentfulContentTypeService::PREPPED_INGREDIENT_ID)

    restaurant_entry = environment.entries.find(restaurant_entry_id)
    prepped_ingredients_entry = environment.entries.find(restaurant_entry.prepped_ingredients["sys"]["id"])

    ingredient_entries = ingredient_entry_ids.map { |entry_id| environment.entries.find(entry_id) }

    prepped_ingredient_entry = prepped_ingredient_content.entries.create(
      name: name,
      price: price,
      restaurant: restaurant_entry,
      ingredients: ingredient_entries
    )

    prepped_ingredient_entry.publish

    prepped_ingredients_entry.prepped_ingredients = [] if prepped_ingredients_entry.prepped_ingredients.nil?
    prepped_ingredients_entry.prepped_ingredients << prepped_ingredient_entry
    prepped_ingredients_entry.update(prepped_ingredients: prepped_ingredients_entry.prepped_ingredients)
    prepped_ingredients_entry.publish

    prepped_ingredient_entry
  end

  def create_meal(name:, price:, restaurant_entry_id:, environment:, ingredient_entry_ids:)
    meal_content = environment.content_types.find(ContentfulContentTypeService::MEAL_ID)

    restaurant_entry = environment.entries.find(restaurant_entry_id)
    meals_entry = environment.entries.find(restaurant_entry.meals["sys"]["id"])

    ingredient_entries = ingredient_entry_ids.map { |entry_id| environment.entries.find(entry_id) }

    meal_entry = meal_content.entries.create(
      name: name,
      price: price,
      restaurant: restaurant_entry,
      ingredients: ingredient_entries
    )

    meal_entry.publish

    meals_entry.meals = [] if meals_entry.meals.nil?
    meals_entry.meals << meal_entry
    meals_entry.update(meals: meals_entry.meals)
    meals_entry.publish

    meal_entry
  end
end
