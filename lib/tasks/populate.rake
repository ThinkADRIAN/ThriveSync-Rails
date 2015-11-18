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

    number_of_pros = 1
    number_of_test_users = 1
    number_of_entries = 100

    random_mood_entries = true
    random_sleep_entries = true
    random_self_care_entries = true
    random_journal_entries = true

    #Rake::Task['db:reset'].invoke

    # Truncate all existing data
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    # Create admin_user account
    admin_user = User.new(:email => "admin@thrivesync.com",
                          :first_name => "ThriveSync",
                          :last_name => "Administrator",
                          :password => "Tiavspw!")
    admin_user.skip_confirmation!
    admin_user.save!

    admin_user.roles = ["superuser"]
    admin_user.save!

    # Create test user pro accounts
    number_of_pros.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name + " (Pro)"
      email = "pro-#{n+1}@thrivesync.com"
      password = "Password1234"
      pro_user = User.new(:first_name => first_name,
                           :last_name => last_name,
                           :email => email,
                           :password => password,
                           :password_confirmation => password)
      pro_user.skip_confirmation!
      pro_user.save!

      pro_user.roles = ["pro"]
      pro_user.created_at = number_of_entries.days.ago
      pro_user.save!
    end

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