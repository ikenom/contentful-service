# frozen_string_literal: true

class ContentfulContentTypeService
  attr_reader :client

  RESTAURANT_ID = "restaurant"
  INGREDIENTS_ID = "ingredients"
  PREPPED_INGREDIENTS_ID = "prepped_ingredients"
  MEALS_ID = "meals"
  INGREDIENT_ID = "ingredient"
  PREPPED_INGREDIENT_ID = "prepped_ingredient"
  MEAL_ID = "meal"

  def initialize(access_token:)
    @client = Contentful::Management::Client.new(access_token)
  end

  def create_space(name:, org_id:)
    client.spaces.create(name: name, organization_id: org_id)
  end

  def create_restaurant_content_type(environment:)
    ingredients_link_content_type_validation = Contentful::Management::Validation.new
    ingredients_link_content_type_validation.link_content_type = [INGREDIENTS_ID]

    prepped_ingredients_link_content_type_validation = Contentful::Management::Validation.new
    prepped_ingredients_link_content_type_validation.link_content_type = [PREPPED_INGREDIENTS_ID]

    meals_link_content_type_validation = Contentful::Management::Validation.new
    meals_link_content_type_validation.link_content_type = [MEALS_ID]

    content_type = environment.content_types.create(name: "Restaurant", id: RESTAURANT_ID)
    content_type.fields.create(id: "name", name: "Name", type: "Text", required: true)
    content_type.fields.create(id: INGREDIENTS_ID, name: "Ingredients", type: "Link", link_type: "Entry", required: true, validations: [ingredients_link_content_type_validation])
    content_type.fields.create(id: PREPPED_INGREDIENTS_ID, name: "Prepped Ingredients", type: "Link", link_type: "Entry", required: true, validations: [prepped_ingredients_link_content_type_validation])
    content_type.fields.create(id: MEALS_ID, name: "Meals", type: "Link", link_type: "Entry", required: true, validations: [meals_link_content_type_validation])

    content_type.update(displayField: "name")
    content_type
  end

  def create_ingredient_content_type(environment:)
    validation_link_content_type = Contentful::Management::Validation.new
    validation_link_content_type.link_content_type = [RESTAURANT_ID]

    content_type = environment.content_types.create(name: "Ingredient", id: INGREDIENT_ID)
    content_type.fields.create(id: "name", name: "Name", type: "Text", required: true)
    content_type.fields.create(id: "price", name: "Price", type: "Number", required: true)
    content_type.fields.create(id: "restaurant", name: "Restaurant", type: "Link", link_type: "Entry", required: true, validations: [validation_link_content_type])
    content_type.update(displayField: "name")
    content_type
  end

  def create_prepped_ingredient_content_type(environment:)
    ingredient_link_content_type_validation = Contentful::Management::Validation.new
    ingredient_link_content_type_validation.link_content_type = [INGREDIENT_ID]

    restaurant_link_content_type = Contentful::Management::Validation.new
    restaurant_link_content_type.link_content_type = [RESTAURANT_ID]

    ingredient_link_field = Contentful::Management::Field.new
    ingredient_link_field.type = "Link"
    ingredient_link_field.link_type = "Entry"
    ingredient_link_field.validations = [ingredient_link_content_type_validation]

    content_type = environment.content_types.create(name: "Prepped Ingredient", id: PREPPED_INGREDIENT_ID)
    content_type.fields.create(id: "name", name: "Name", type: "Text", required: true)
    content_type.fields.create(id: "price", name: "Price", type: "Number", required: true)
    content_type.fields.create(id: "restaurant", name: "Restaurant", type: "Link", link_type: "Entry", required: true, validations: [restaurant_link_content_type])
    content_type.fields.create(id: "ingredients", name: "Ingredients", type: "Array", items: ingredient_link_field, required: true)

    content_type.update(displayField: "name")
    content_type
  end

  def create_meal_content_type(environment:)
    ingredient_link_content_type_validation = Contentful::Management::Validation.new
    ingredient_link_content_type_validation.link_content_type = [INGREDIENT_ID, PREPPED_INGREDIENT_ID]

    restaurant_link_content_type = Contentful::Management::Validation.new
    restaurant_link_content_type.link_content_type = [RESTAURANT_ID]

    ingredient_link_field = Contentful::Management::Field.new
    ingredient_link_field.type = "Link"
    ingredient_link_field.link_type = "Entry"
    ingredient_link_field.validations = [ingredient_link_content_type_validation]

    content_type = environment.content_types.create(name: "Meal", id: MEAL_ID)
    content_type.fields.create(id: "name", name: "Name", type: "Text", required: true)
    content_type.fields.create(id: "price", name: "Price", type: "Number", required: true)
    content_type.fields.create(id: "restaurant", name: "Restaurant", type: "Link", link_type: "Entry", required: true, validations: [restaurant_link_content_type])
    content_type.fields.create(id: "ingredients", name: "Ingredients", type: "Array", items: ingredient_link_field, required: true)

    content_type.update(displayField: "name")
    content_type
  end

  def create_category_content_type(environment:, name:, id:, validation_id:)
    validation_link_content_type = Contentful::Management::Validation.new
    validation_link_content_type.link_content_type = [validation_id]

    link_field = Contentful::Management::Field.new
    link_field.type = "Link"
    link_field.link_type = "Entry"
    link_field.validations = [validation_link_content_type]

    content_type = environment.content_types.create(name: name, id: id)
    content_type.fields.create(id: "name", name: "Name", type: "Text", required: true)
    content_type.fields.create(id: id, name: name, type: "Array", items: link_field)
    content_type.update(displayField: "name")
    content_type
  end
end
