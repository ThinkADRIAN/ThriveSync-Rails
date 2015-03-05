# lib/tasks/populate.rake
#
# Rake task to populate development database with test data
# Run it with "rake db:populate"
# See Railscast 126 and the faker website for more information
#
# http://www.jacoulter.com/2011/12/21/rails-using-faker-to-populate-a-development-database/

namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'

    Rake::Task['db:reset'].invoke

    # Create admin_user account
    admin_user = RailsUser.create!(:email => "admin@thrivetracker.co",
      :first_name => "ThriveTracker",
      :last_name => "Administrator",
      :password => "Tiavspw!")
    admin_user.roles = ["superuser"]
    admin_user.skip_confirmation!
    admin_user.save!

    # Create test user pro accounts
    10.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name + " (Pro)"
      email = "test-#{n+1}@thrivetracker.co"
      password = "Password123"
      test_user = RailsUser.create!(:first_name => first_name,
        :last_name => last_name,
        :email => email,
        :password => password,
        :password_confirmation => password)
      test_user.roles = ["pro"]
      test_user.skip_confirmation!
      test_user.save!

      # Create moods for test user
      28.times do |d|

        now = Time.now

        mood = Mood.create!(:mood_rating => rand(1..7),
          :anxiety_rating => rand(1..4),
          :irritability_rating => rand(1..4),
          :user_id => test_user.id)
        mood.timestamp = d.days.ago
        mood.created_at = d.days.ago
        mood.updated_at = d.days.ago
        mood.save!

        sleep_start_time = Faker::Time.between((d).days.ago, Time.now, :morning)#rand(now-d.days.ago)
        sleep_finish_time = sleep_start_time + rand(1..10).hours

        sleep = Sleep.create!(:start_time => sleep_start_time.change(:sec => 0),
          :finish_time => sleep_finish_time.change(:sec => 0),
          :time => (sleep_finish_time.to_i - sleep_start_time.to_i) / 3600,
          :quality => rand(1..4),
          :user_id => test_user.id)
        sleep.created_at = d.days.ago
        sleep.updated_at = d.days.ago
        sleep.save!

        random_bool = [true, false].sample

        self_care = SelfCare.create!(:counseling => [true, false].sample,
          :medication => [true,false].sample,
          :meditation => [true,false].sample,
          :exercise => [true,false].sample,
          :user_id => test_user.id)
        self_care.created_at = d.days.ago
        self_care.updated_at = d.days.ago
        self_care.save!

        journal_entry = Faker::Lorem.paragraph(sentence_count = rand(1..38))
        journal_entered = [true,false].sample

        if journal_entered
          journal = Journal.create!(:journal_entry => journal_entry,
            :user_id => test_user.id)
          journal.created_at = d.days.ago
          journal.updated_at = d.days.ago
          journal.save!
        end
      end
    end

    # Create test user accounts
    10.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name + " (User)"
      email = "test-#{n+11}@thrivetracker.co"
      password = "Password123"
      test_user = RailsUser.create!(:first_name => first_name,
        :last_name => last_name,
        :email => email,
        :password => password,
        :password_confirmation => password)
      test_user.roles = ["user"]
      test_user.skip_confirmation!
      test_user.save!

      # Create moods for test user
      28.times do |d|

        now = Time.now

        mood = Mood.create!(:mood_rating => rand(1..7),
          :anxiety_rating => rand(1..4),
          :irritability_rating => rand(1..4),
          :user_id => test_user.id)
        mood.timestamp = d.days.ago
        mood.created_at = d.days.ago
        mood.updated_at = d.days.ago
        mood.save!

        sleep_start_time = Faker::Time.between((d).days.ago, Time.now, :morning)#rand(now-d.days.ago)
        sleep_finish_time = sleep_start_time + rand(1..10).hours

        sleep = Sleep.create!(:start_time => sleep_start_time.change(:sec => 0),
          :finish_time => sleep_finish_time.change(:sec => 0),
          :time => (sleep_finish_time.to_i - sleep_start_time.to_i) / 3600,
          :quality => rand(1..4),
          :user_id => test_user.id)
        sleep.created_at = d.days.ago
        sleep.updated_at = d.days.ago
        sleep.save!

        random_bool = [true, false].sample

        self_care = SelfCare.create!(:counseling => [true, false].sample,
          :medication => [true,false].sample,
          :meditation => [true,false].sample,
          :exercise => [true,false].sample,
          :user_id => test_user.id)
        self_care.created_at = d.days.ago
        self_care.updated_at = d.days.ago
        self_care.save!

        journal_entry = Faker::Lorem.paragraph(sentence_count = rand(1..38))
        journal_entered = [true,false].sample

        if journal_entered
          journal = Journal.create!(:journal_entry => journal_entry,
            :user_id => test_user.id)
          journal.created_at = d.days.ago
          journal.updated_at = d.days.ago
          journal.save!
        end
      end
    end

    # Create client Relationships
    rails_users = RailsUser.all
    inviter = []
    invitee = []

    rails_users.each do |user|
      if user.roles.include? "pro"
        inviter << user
      end
    end  

    rails_users.each do |user|
      if user.roles.include? "user"
        invitee << user
      end
    end  

    inviter.each do |i|
      a = invitee.sample
      i.invite a
      a.approve i
      i.clients += [a.id.to_i]
      i.save!
    end
  end
end