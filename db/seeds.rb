#Create users
5.times do
  user = User.create!(
    name: Faker::Internet.unique.user_name,
    email: Faker::Internet.unique.safe_email,
    password: Faker::Internet.password(8)
  )

  user.confirm
end
users = User.all

#Create Wikis
50.times do
  Wiki.create!(
    user: users.sample,
    title: Faker::RockBand.unique.name,
    body: Faker::MostInterestingManInTheWorld.quote
  )
end

# Create an admin user
admin = User.create!(
  name: 'Admin User',
  email: 'admin@example.com',
  password: 'helloworld',
  role: 'admin'
)
admin.confirm

# Create a standard user
standard = User.create!(
  name: 'Standard User',
  email: 'member@example.com',
  password: 'helloworld',
)
standard.confirm

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
