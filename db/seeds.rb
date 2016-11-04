# Cases we should cover with seeds
# - User with no resources, no lists, no groups
# - User with no resources, one list, no groups
# - User with resource, list, group
# - User with one group, no list
# - Group with all users, one list
# - Group with 2 users, no list
# - Resource belongs to a user, and two lists
# - Resource belongs to no user, and two lists
# - Resource belongs to one list
# - User's list
# - User's list
# - Group's list

# Create users
5.times do |n|
  User.create(
    email: "user#{n}@greencommons.org",
    password: 'thecommons'
  )
end

# Create 50 fake unowned resources
50.times do
  Resource.create(
    title: Faker::Book.title,
    resource_type: Resource.resource_types.keys.sample
  )
end

# Create 50 fake owned resources
50.times do
  Resource.create(
    title: Faker::Book.title,
    user: User.all.sample,
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

# Make lists for everyone
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
