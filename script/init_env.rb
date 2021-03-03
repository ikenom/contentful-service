require 'contentful/management'

ACCESS_TOKEN = 'CFPAT-klmCDVSL0_IFZ4lvCZ78WZ0Pk4u8pMVRFyC4XcSjY5g'
SPACE_ID = "gdnbla9utfkg"

client = Contentful::Management::Client.new(ACCESS_TOKEN)
space = client.spaces.all.filter {|d| d.name == 'fytr'}.first
environment = space.environments.find("master")

restaurant_content = environment.content_types.find("restaurant")
ingredients_content = environment.content_types.find("ingredients")
prepped_ingredients_content = environment.content_types.find("prepped_ingredients")
meals_content = environment.content_types.find("meals")

name = "Test Restaurant"
ie = ingredients_content.entries.create(name: name)
pie = prepped_ingredients_content.entries.create(name: name)
m = meals_content.entries.create(name: name)

[ie, pie, m].each(&:publish)

restaurant_entry = restaurant_content.entries.create(
  name: name,
  ingredients: ie,
  prepped_ingredients: pie,
  meals: m)

restaurant_entry.publish

