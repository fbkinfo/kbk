require 'factory_girl'
require Rails.root.join("spec/support/file_fixtures.rb")

FactoryGirl.find_definitions

puts "=> Seeding base..."

password = "123456789"
user   = FactoryGirl.create(:user, email: 'epic@lawyer.ru', password: password, password_confirmation: password, role: "admin")
author = Author.first

puts "=> Seeding investigations..."

cases = FactoryGirl.create_list(:investigation, 3, user: user)

puts "=> Seeding cases..."

cases.each do |c|
  organizations = FactoryGirl.create_list(:organization, 2)

  FactoryGirl.create_list(:document, 4, user: user, author: author, investigation: c, organization: organizations.sample)
end

puts "Finished! You can login with: #{user.email} #{password}"
