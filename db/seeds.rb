# config
users_count = 20
resources_count = 400
groups_count = 10

p "Creating #{users_count} users..."
users_count.times do |n|
  FactoryGirl.create(:user, email: "user#{n}@greencommons.org",
                            password: 'thecommons')
end

p "Creating #{resources_count} resources..."
(resources_count / 2).times do |n|
  # unowned resources
  FactoryGirl.create(:resource)

  # owned resources
  FactoryGirl.create(:resource, user: User.all.sample)
end

p 'Creating 2 lists with 10-50 resources for each user...'
User.all.each do |user|
  FactoryGirl.create_list(:list, 2, owner: user,
                                    resources: Resource.order('RANDOM()').limit(rand(10..50)))
end

p "Creating #{groups_count} groups and 3-5 lists with 30-80 resources for each group..."
groups_count.times do |n|
  group = FactoryGirl.create(:group)
  users = User.order('RANDOM()').limit(rand(2..10)).to_a

  group.add_admin(User.first)
  group.add_admin(users.shift)
  users.each { |user| group.add_user(user) }

  FactoryGirl.create_list(:list, rand(3..5), owner: group,
                                             resources: Resource.order('RANDOM()').limit(rand(30..80)))
end
