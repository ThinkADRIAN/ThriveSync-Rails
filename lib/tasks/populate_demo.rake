# lib/tasks/populate.rake
#
# Rake task to populate development database with test data
# Run it with "rake db:populate_demo"
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
      user.research_started_at = 100.days.ago
      user.save!
    end
  end
end

def get_demo_users(user_type, quantity)
  demo_users = []

  quantity.times do |n|
    if user_type == 'admin'
      email = "admin-#{n+1}@thrivesync.com"
    elsif user_type == 'pro'
      email = "pro-#{n+1}@thrivesync.com"
    elsif user_type == "supporter"
      email = "supporter-#{n+1}@thrivesync.com"
    elsif user_type == "thriver"
      email = "thriver-#{n+1}@thrivesync.com"
    end

    if user_exists?(email)
      user = User.where(email: email).first
      demo_users << user
    end
  end
  return demo_users
end

def user_exists?(email)
  !User.where(email: email).empty?
end

def get_last_entry_date(user, data_type)
  if data_type == 'mood'
    Mood.where(user_id: user.id).order("created_at").last.created_at
  elsif data_type == 'sleep'
    Sleep.where(user_id: user.id).order("created_at").last.created_at
  elsif data_type == 'self_care'
    SelfCare.where(user_id: user.id).order("created_at").last.created_at
  elsif data_type == 'journal'
    Journal.where(user_id: user.id).order("created_at").last.created_at
  end
end

def days_since_last_entry(user, data_type)
  if data_type == 'mood'
    last_entry_date = get_last_entry_date(user, 'mood')
  elsif data_type == 'sleep'
    last_entry_date = get_last_entry_date(user, 'sleep')
  elsif data_type == 'self_care'
    last_entry_date = get_last_entry_date(user, 'self_care')
  elsif data_type == 'journal'
    last_entry_date = get_last_entry_date(user, 'journal')
  end
  (Date.today - last_entry_date.to_date).to_int
end

def number_of_data_entries(user, data_type)
  if data_type == 'mood'
    Mood.where(user_id: user.id).count('created_at', :distinct => true)
  elsif data_type == 'sleep'
    Sleep.where(user_id: user.id).count('created_at', :distinct => true)
  elsif data_type == 'self_care'
    SelfCare.where(user_id: user.id).count('created_at', :distinct => true)
  elsif data_type == 'journal'
    Journal.where(user_id: user.id).count('created_at', :distinct => true)
  end
end

def create_mood_entries(user, number_of_entries, randomize_entries)
  number_of_entries.times do |d|
    if randomize_entries
      mood_entered = [true, false].sample
    else
      mood_entered = true
    end

    if mood_entered
      mood = Mood.create!(:mood_rating => rand(1..7),
                          :anxiety_rating => rand(1..4),
                          :irritability_rating => rand(1..4),
                          :user_id => user.id,
                          :timestamp => (number_of_entries - d).days.ago)
      mood.created_at = (number_of_entries - d).days.ago
      mood.updated_at = (number_of_entries - d).days.ago
      mood.save!

      user.scorecard.update_scorecard('moods', (number_of_entries - d).days.ago)
    end
  end
end

def create_sleep_entries(user, number_of_entries, randomize_entries)
  number_of_entries.times do |d|
    if randomize_entries
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
                            :user_id => user.id)
      sleep.created_at = (number_of_entries - d).days.ago
      sleep.updated_at = (number_of_entries - d).days.ago
      sleep.save!

      user.scorecard.update_scorecard('sleeps', ( number_of_entries - d ).days.ago)
    end
  end
end

def create_self_care_entries(user, number_of_entries, randomize_entries)
  number_of_entries.times do |d|
    if randomize_entries
      self_care_entered = [true, false].sample
    else
      self_care_entered = true
    end

    if self_care_entered
      self_care = SelfCare.create!(:counseling => [true, false].sample,

                                   :medication => [true, false].sample,
                                   :meditation => [true, false].sample,
                                   :exercise => [true, false].sample,
                                   :user_id => user.id,
                                   :timestamp => (number_of_entries - d).days.ago)
      self_care.created_at = (number_of_entries - d).days.ago
      self_care.updated_at = (number_of_entries - d).days.ago
      self_care.save!

      user.scorecard.update_scorecard('self_cares', (number_of_entries - d).days.ago)
    end
  end
end

def create_journal_entries(user, number_of_entries, randomize_entries)
  number_of_entries.times do |d|
    if randomize_entries
      journal_entered = [true, false].sample
    else
      journal_entered = true
    end

    if journal_entered
      journal_entry = Faker::Lorem.paragraph(sentence_count = rand(1..38))
      journal = Journal.create!(:journal_entry => journal_entry,
                                :user_id => user.id,
                                :timestamp => (number_of_entries - d).days.ago)
      journal.created_at = (number_of_entries - d).days.ago
      journal.updated_at = (number_of_entries - d).days.ago
      journal.save!
      user.scorecard.update_scorecard('journals', (number_of_entries - d).days.ago)
    end
  end
end

namespace :db do
  desc "Setup Demo with Users and Up-to-date Data"
  task :populate_demo => :environment do
    require 'faker'

    number_of_admins = 1
    number_of_pros = 3
    number_of_supporters = 3
    number_of_thrivers = 8

    number_of_entries = 100

    random_mood_entries = true
    random_sleep_entries = true
    random_self_care_entries = true
    random_journal_entries = true

    # Create User Accounts

    create_user('admin', number_of_admins)
    create_user('pro', number_of_pros)
    create_user('supporter', number_of_supporters)
    create_user('thriver', number_of_thrivers)

    # Get Demo Users
    demo_users = get_demo_users('thriver', number_of_thrivers)

    # Create Data to Present
    demo_users.each do |user|
      if number_of_data_entries(user, 'mood') > 0
        days_since_last_mood_entry = days_since_last_entry(user,'mood')
        if days_since_last_mood_entry > 1
          create_mood_entries(user, days_since_last_mood_entry, random_mood_entries)
        end
      elsif number_of_data_entries(user, 'mood') == 0
        create_mood_entries(user, number_of_entries, random_mood_entries)
      end

      if number_of_data_entries(user, 'sleep') > 0
        days_since_last_sleep_entry = days_since_last_entry(user,'sleep')
        if days_since_last_sleep_entry > 1
          create_sleep_entries(user, days_since_last_sleep_entry, random_sleep_entries)
        end
      elsif number_of_data_entries(user, 'sleep') == 0
        create_sleep_entries(user, number_of_entries, random_sleep_entries)
      end

      if number_of_data_entries(user, 'self_care') > 0
        days_since_last_self_care_entry = days_since_last_entry(user,'self_care')
        if days_since_last_self_care_entry > 1
          create_self_care_entries(user, days_since_last_self_care_entry, random_self_care_entries)
        end
      elsif number_of_data_entries(user, 'self_care') == 0
        create_self_care_entries(user, number_of_entries, random_self_care_entries)
      end

      if number_of_data_entries(user, 'journal') > 0
        days_since_last_journal_entry = days_since_last_entry(user,'journal')
        if days_since_last_journal_entry > 1
          create_journal_entries(user, days_since_last_journal_entry, random_journal_entries)
        end
      elsif number_of_data_entries(user, 'journal') == 0
        create_journal_entries(user, number_of_entries, random_journal_entries)
      end
    end

    # Create Client Relationships
    inviter = []
    invitee = []

    demo_users = get_demo_users('pro', number_of_pros)
    demo_users.each do |user|
      if user.roles.include? "pro"
        inviter << user
      end
    end

    demo_users = get_demo_users('thriver', number_of_thrivers)
    demo_users.each do |user|
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

    first_thriver = User.where(email: "thriver-1@thrivesync.com").first

    # Create Client Relationship for Thiver-1 & Pro-1
    first_pro = User.where(email: "pro-1@thrivesync.com").first

    if (!first_pro.clients.include? first_thriver.id.to_i)
      first_pro.friend_request(first_thriver)
      first_thriver.accept_request(first_pro)
      first_pro.clients += [first_thriver.id.to_i]
      first_pro.save!
    end

    # Create Supporter Connections for Thriver-1 & Supporter-1
    first_supporter = User.where(email: "supporter-1@thrivesync.com").first

    if (!first_thriver.supporters.include? first_supporter.id.to_i) && (!first_supporter.thrivers.include? first_thriver.id.to_i)
      first_thriver.supporters += [first_supporter.id.to_i]
      first_thriver.save!
      first_thriver.friend_request(first_supporter)

      first_supporter.thrivers += [first_thriver.id.to_i]
      first_supporter.accept_request(first_thriver)
      first_supporter.save!
    end
  end
end