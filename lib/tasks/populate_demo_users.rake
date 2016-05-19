# lib/tasks/populate.rake
#
# Rake task to populate development database with test data
# Run it with "rake db:populate"
# See Railscast 126 and the faker website for more information
#
# http://www.jacoulter.com/2011/12/21/rails-using-faker-to-populate-a-development-database/

def create_user(user_type, quantity)
  quantity.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name

    if user_type == 'admin'
      email = "admin-#{n+1}@thrivesync.com"
      password = "Tiavspw!"
      roles = ["superuser"]
    elsif user_type == 'pro'
      email = "pro-#{n+1}@thrivesync.com"
      password = "Password1234"
      roles = ["pro"]
    elsif user_type == "supporter"
      email = "supporter-#{n+1}@thrivesync.com"
      password = "Password1234"
      roles = ["supporter"]
    elsif user_type == "thriver"
      email = "thriver-#{n+1}@thrivesync.com"
      password = "Password1234"
      roles = ["user"]
    end

    if !user_exists?(email)
      user = User.new(:first_name => first_name,
                      :last_name => last_name,
                      :email => email,
                      :password => password,
                      :password_confirmation => password)
      user.skip_confirmation!
      user.save!

      user.roles = roles
      user.save!
    end
  end
end

def user_exists?(email)
  !User.where(email: email).empty?
end

namespace :db do
  desc "Create Test Users As Needed"
  task :populate_demo_users => :environment do
    require 'faker'

    number_of_admins = 1
    number_of_pros = 3
    number_of_supporters = 3
    number_of_thrivers = 8

    # Create User Accounts
    create_user('admin', number_of_admins)
    create_user('pro', number_of_pros)
    create_user('supporter', number_of_supporters)
    create_user('thriver', number_of_thrivers)

    # Create client Relationships
    users = User.all
    inviter = []
    invitee = []

    users.each do |user|
      if user.roles.include? "pro"
        inviter << user
      end
    end

    users.each do |user|
      if user.roles.include? "user"
        invitee << user
      end
    end

    inviter.each do |i|
      a = invitee.sample
      i.friend_request(a)
      a.accept_request(i)
      i.clients += [a.id.to_i]
      i.save!
    end
  end
end