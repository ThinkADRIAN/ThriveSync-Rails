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

def user_exists?(email)
  User.where(email: email).empty?
end

namespace :db do
  desc "Erase and fill database"
  task :populate_demo => :environment do
    require 'faker'

    number_of_entries = 10

    random_mood_entries = true
    random_sleep_entries = true
    random_self_care_entries = true
    random_journal_entries = true

    # If necessary, create Users


    # Initialize User Accounts
    admin_user = User.where(email: "admin@thrivesync.com").first
    pro_user = User.where(email: "pro1@thrivesync.com").first
    thriver = User.where(email: "thriver@thrivesync.com").first
    supporter = User.where(email: "supporter@thrivesync.com").first

    # Create test user accounts
    number_of_test_users.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name + " (User)"
      email = "test-#{n+1}@thrivesync.com"
      password = "Password1234"
      test_user = User.new(:first_name => first_name,
                           :last_name => last_name,
                           :email => email,
                           :password => password,
                           :password_confirmation => password)
      test_user.skip_confirmation!
      test_user.save!

      test_user.roles = ["user"]
      test_user.created_at = number_of_entries.days.ago
      test_user.save!

      # Create moods for test user
      number_of_entries.times do |d|

        if random_mood_entries
          mood_entered = [true, false].sample
        else
          mood_entered = true
        end

        if mood_entered
          mood = Mood.create!(:mood_rating => rand(1..7),
                              :anxiety_rating => rand(1..4),
                              :irritability_rating => rand(1..4),
                              :user_id => test_user.id,
                              :timestamp => (number_of_entries - d).days.ago)
          mood.created_at = (number_of_entries - d).days.ago
          mood.updated_at = (number_of_entries - d).days.ago
          mood.save!

          test_user.scorecard.update_scorecard('moods', (number_of_entries - d).days.ago)
        end

        if random_sleep_entries
          sleep_entered = [true, false].sample
        else
          sleep_entered = true
        end

        if sleep_entered
          #sleep_start_time = Faker::Time.between((number_of_entries - d - 1).days.ago, (number_of_entries - d - 1).days.ago, :evening) #rand(now-d.days.ago)
          #sleep_finish_time = sleep_start_time + rand(1..10).hours

          sleep_finish_time = Faker::Time.between((number_of_entries - d).days.ago, (number_of_entries - d).days.ago, :morning) #rand(now-d.days.ago)
          sleep_start_time = sleep_finish_time - rand(1..10).hours

          sleep = Sleep.create!(:start_time => sleep_start_time.change(:sec => 0),
                                :finish_time => sleep_finish_time.change(:sec => 0),
                                :time => (sleep_finish_time.to_i - sleep_start_time.to_i) / 3600,
                                :quality => rand(1..4),
                                :user_id => test_user.id)
          sleep.created_at = (number_of_entries - d).days.ago
          sleep.updated_at = (number_of_entries - d).days.ago
          sleep.save!

          test_user.scorecard.update_scorecard('sleeps', ( number_of_entries - d ).days.ago)
        end

        if random_self_care_entries
          self_care_entered = [true, false].sample
        else
          self_care_entered = true
        end

        if self_care_entered
          self_care = SelfCare.create!(:counseling => [true, false].sample,

                                       :medication => [true, false].sample,
                                       :meditation => [true, false].sample,
                                       :exercise => [true, false].sample,
                                       :user_id => test_user.id,
                                       :timestamp => (number_of_entries - d).days.ago)
          self_care.created_at = (number_of_entries - d).days.ago
          self_care.updated_at = (number_of_entries - d).days.ago
          self_care.save!

          test_user.scorecard.update_scorecard('self_cares', (number_of_entries - d).days.ago)
        end

        if random_journal_entries
          journal_entered = [true, false].sample
        else
          journal_entered = true
        end

        if journal_entered
          journal_entry = Faker::Lorem.paragraph(sentence_count = rand(1..38))
          journal = Journal.create!(:journal_entry => journal_entry,
                                    :user_id => test_user.id,
                                    :timestamp => (number_of_entries - d).days.ago)
          journal.created_at = (number_of_entries - d).days.ago
          journal.updated_at = (number_of_entries - d).days.ago
          journal.save!
          test_user.scorecard.update_scorecard('journals', (number_of_entries - d).days.ago)
        end
      end
    end

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