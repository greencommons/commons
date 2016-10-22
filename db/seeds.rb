# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create users
(1..5).each do |n|
  User.create(
    email: "user#{n}@greencommons.org",
    password: 'thecommons'
  )
end

# Create 100 fake resources
(0..100).each do |n|
  Resource.create(
    title: Faker::Book.title,
    resource_type: Resource.resource_types.keys.sample
  )
end

# Create 2 groups
g = Group.create(
  name: 'Sample Group',
  short_description: Faker::Lorem.sentence,
  long_description: Faker::Lorem.paragraph,
  url: Faker::Internet.url,
  email: Faker::Internet.email
)

# Assign 2 users to group
g.users << User.all.sample(2)


g2 = Group.create(
  name: 'Full Group',
  short_description: Faker::Lorem.sentence,
  long_description: Faker::Lorem.paragraph,
  url: Faker::Internet.url,
  email: Faker::Internet.email
)

# Assign 2 users to group
g2.users << User.all

User.all.each do |user|
  user.lists.create(
    name: Faker::Book.title,
    resources: Resource.all.sample(rand(10..20))
  )
end


2.times do
  Group.first.lists.create(
    name: Faker::Book.title,
    resources: Resource.all.sample(rand(30..50))
  )
end

# Cases we should cover with seeds
# User with no resources, no lists, no groups
# User with no resources, one list, no groups
# User with resource, list, group
# User with one group, no list

# Group with all users, one list
# Group with 2 users, no list

# Resource belongs to a user, and two lists
# Resource belongs to no user, and two lists
# Resource belongs to one list

# User's list
# User's list
# Group's list