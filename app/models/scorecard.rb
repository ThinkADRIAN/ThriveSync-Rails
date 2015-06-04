class Scorecard < ActiveRecord::Base
=begin
  Open Issues:
    - These attributes are not working:
      "streak_count": 0,
      "streak_record": 0
    - Streak Count and Streak Record not working for data types
=end

  belongs_to :user

  after_initialize :init

  def init
    self.checkin_count  ||= 0
    self.perfect_checkin_count ||= 0
    self.streak_count ||= 0
    self.moods_score ||= 0
    self.sleeps_score ||= 0
    self.self_cares_score ||= 0
    self.journals_score ||= 0
    self.streak_record ||= 0
    self.level_multiplier ||= 1
    self.days_since_signup ||= 0
    self.mood_checkin_count ||= 0
    self.mood_streak_count ||= 0
    self.mood_streak_record ||= 0
    self.mood_level_multiplier ||= 1
    self.sleep_checkin_count ||= 0
    self.sleep_streak_count ||= 0
    self.sleep_streak_record ||= 0
    self.sleep_level_multiplier ||= 1
    self.self_care_checkin_count ||= 0
    self.self_care_streak_count ||= 0
    self.self_care_streak_record ||= 0
    self.self_care_level_multiplier ||= 1
    self.journal_checkin_count ||= 0
    self.journal_streak_count ||= 0
    self.journal_streak_record ||= 0
    self.journal_level_multiplier ||= 1
  end

  def increment_checkin_count(data_type)
    if data_type == 'moods'
      self.mood_checkin_count += 1
    elsif data_type == 'sleeps'
      self.sleep_checkin_count += 1
    elsif data_type == 'self_cares'
      self.self_care_checkin_count += 1
    elsif data_type == 'journals'
      self.journal_checkin_count += 1
    end
    self.checkin_count += 1
    self.save
  end

  def checkin_yesterday?(data_type)
    if data_type == 'moods'
      if self.mood_last_checkin_date != nil
        self.mood_last_checkin_date.to_date == DateTime.yesterday
      end
    elsif data_type == 'sleeps'
      if self.sleep_last_checkin_date != nil
        self.sleep_last_checkin_date.to_date == DateTime.yesterday
      end
    elsif data_type == 'self_cares'
      if self.self_care_last_checkin_date != nil
        self.self_care_last_checkin_date.to_date == DateTime.yesterday
      end
    elsif data_type == 'journals'
      if self.journal_last_checkin_date != nil
        self.journal_last_checkin_date.to_date == DateTime.yesterday
      end
    end
  end

  def increment_perfect_checkin_count
    self.perfect_checkin_count += 1
    self.save
  end

  def set_last_perfect_checkin_date(checkin_date)
    self.update_attribute(:last_perfect_checkin_date, checkin_date)
  end

  def perfect_checkin_today?
    todays_date = DateTime.now.to_date

    last_mood_entry = Mood.where(user_id: self.user_id)
    if last_mood_entry.empty?
      return false
    else
      last_moods_date = last_mood_entry.last.created_at_before_type_cast.to_datetime.to_date
    end

    last_sleep_entry = Sleep.where(user_id: self.user_id)
    if last_sleep_entry.empty?
      return false
    else
      last_sleeps_date = last_sleep_entry.last.created_at_before_type_cast.to_datetime.to_date
    end

    last_self_care_entry = SelfCare.where(user_id: self.user_id)
    if last_self_care_entry.empty?
      return false
    else
      last_self_cares_date = last_self_care_entry.last.created_at_before_type_cast.to_datetime.to_date
    end

    last_journal_entry = Journal.where(user_id: self.user_id)
    if last_journal_entry.empty?
      return false
    else
      last_journals_date = last_journal_entry.last.created_at_before_type_cast.to_datetime.to_date
    end

    return ( last_moods_date == todays_date && 
      last_sleeps_date == todays_date && 
      last_self_cares_date == todays_date && 
      last_journals_date == todays_date )
  end

  def set_last_checkin_date(data_type, checkin_date)
    if data_type == 'moods'
      self.update_attribute(:mood_last_checkin_date, checkin_date)
    elsif data_type == 'sleeps'
      self.update_attribute(:sleep_last_checkin_date, checkin_date)
    elsif data_type == 'self_cares'
      self.update_attribute(:self_care_last_checkin_date, checkin_date)
    elsif data_type == 'journals'
      self.update_attribute(:journal_last_checkin_date, checkin_date)
    end
    self.update_attribute(:last_checkin_date, checkin_date)
    self.save
  end

  def increment_streak_count(data_type)
    if data_type == 'moods'
      self.mood_streak_count += 1
    elsif data_type == 'sleeps'
      self.sleep_streak_count += 1
    elsif data_type == 'self_cares'
      self.self_care_streak_count += 1
    elsif data_type == 'journals'
      self.journal_streak_count += 1
    end
    if self.last_checkin_date.to_date != DateTime.now.to_date
      self.last_checkin_date += 1
    end
    self.save
  end

  def update_main_streak_count
    streak_counts = []
    streak_counts.push(self.mood_streak_count)
    streak_counts.push(self.sleep_streak_count)
    streak_counts.push(self.self_care_streak_count)
    streak_counts.push(self.journal_streak_count)
    self.streak_count = streak_counts.max
    self.save
  end

  def reset_streak_count(data_type)
    if data_type == 'moods'
      self.mood_streak_count = 0
    elsif data_type == 'sleeps'
      self.sleep_streak_count = 0
    elsif data_type == 'self_cares'
      self.self_care_streak_count = 0
    elsif data_type == 'journals'
      self.journal_streak_count = 0
    end
    self.save
  end

  def update_streak_record(data_type)
    if data_type == 'moods' && (self.mood_last_checkin_date != nil) && self.mood_last_checkin_date.to_date != DateTime.now.to_date
      if self.mood_streak_record <= self.mood_streak_count
        self.mood_streak_record += 1
      end
    elsif data_type == 'sleeps' && (self.sleep_last_checkin_date != nil) && self.sleep_last_checkin_date.to_date != DateTime.now.to_date
      if self.sleep_streak_record <= self.sleep_streak_count
        self.sleep_streak_record += 1
      end
    elsif data_type == 'self_cares' && (self.self_care_last_checkin_date != nil) && self.self_care_last_checkin_date.to_date != DateTime.now.to_date
      if self.self_care_streak_record <= self.self_care_streak_count
        self.self_care_streak_record += 1
      end
    elsif data_type == 'journals' && (self.journal_last_checkin_date != nil) && self.journal_last_checkin_date.to_date != DateTime.now.to_date
      if self.journal_streak_record <= self.journal_streak_count
        self.journal_streak_record += 1
      end
    end
    self.save
  end

  def update_main_streak_record
    streak_records = []
    streak_records.push(self.mood_streak_record)
    streak_records.push(self.sleep_streak_record)
    streak_records.push(self.self_care_streak_record)
    streak_records.push(self.journal_streak_record)
    self.streak_record = streak_records.max
    self.save
  end

  def calculate_days_since_signup
    user_signup_date = User.find(self.user_id).created_at_before_type_cast.to_datetime
    days_since_signup = (DateTime.now - user_signup_date).to_i
    self.days_since_signup = days_since_signup
    self.save
  end

  def set_level_multiplier(data_type)
    data_type_checkin_count = self.get_data_type_checkin_count(data_type)

    if data_type_checkin_count < 7
      self.increment_level_multiplier(data_type, 1)
    elsif data_type_checkin_count >= 7 && data_type_checkin_count < 14
      self.increment_level_multiplier(data_type, 2)
    elsif data_type_checkin_count >= 14 && data_type_checkin_count < 21
      self.increment_level_multiplier(data_type, 4)
    elsif data_type_checkin_count >= 21 && data_type_checkin_count < 90
      self.increment_level_multiplier(data_type, 6)
    elsif data_type_checkin_count >= 90 && data_type_checkin_count < 120
      self.increment_level_multiplier(data_type, 8)
    elsif data_type_checkin_count >= 120
      self.increment_level_multiplier(data_type, 10)
    end
    self.level_multiplier = ((self.mood_level_multiplier + self.sleep_level_multiplier + self.self_care_level_multiplier + self.journal_level_multiplier) / 4.to_f ).ceil
    self.save 
  end

  def get_data_type_checkin_count(data_type)
    if data_type == 'moods'
      self.mood_checkin_count
    elsif data_type == 'sleeps'
      self.sleep_checkin_count
    elsif data_type == 'self_cares'
      self.self_care_checkin_count
    elsif data_type == 'journals'
      self.journal_checkin_count
    end
  end

  def increment_level_multiplier(data_type, increment)
    if data_type == 'moods'
      self.mood_level_multiplier = increment
    elsif data_type == 'sleeps'
      self.sleep_level_multiplier = increment
    elsif data_type == 'self_cares'
      self.self_care_level_multiplier = increment
    elsif data_type == 'journals'
      self.journal_level_multiplier = increment
    end
  end

  def calculate_score(data_type)
    days_since_signup = self.days_since_signup

    if data_type == 'moods'
      self.moods_score = (((self.mood_checkin_count + days_since_signup)) + (self.mood_streak_count + self.mood_streak_record)) * self.mood_level_multiplier
      self.save
      self.moods_score
    elsif data_type == 'sleeps'
      self.sleeps_score = (((self.sleep_checkin_count + days_since_signup)) + (self.sleep_streak_count + self.sleep_streak_record)) * self.sleep_level_multiplier
      self.save
      self.sleeps_score
    elsif data_type == 'self_cares'
      self.self_cares_score = (((self.self_care_checkin_count + days_since_signup)) + (self.self_care_streak_count + self.self_care_streak_record)) * self.self_care_level_multiplier
      self.save
      self.self_cares_score
    elsif data_type == 'journals'
      self.journals_score = (((self.journal_checkin_count + days_since_signup)) + (self.journal_streak_count + self.journal_streak_record)) * self.journal_level_multiplier
      self.save
      self.journals_score
    end
  end

  def update_score(data_type, new_score)
    if data_type == 'moods'
      self.moods_score = self.calculate_score('moods')
    elsif data_type == 'sleeps'
      self.sleeps_score = self.calculate_score('sleeps')
    elsif data_type == 'self_cares'
      self.self_cares_score = self.calculate_score('self_cares')
    elsif data_type == 'journals'
      self.journals_score = self.calculate_score('journals')
    end
    self.save
  end

  def set_total_score
    self.total_score = self.moods_score + self.sleeps_score + self.self_cares_score + self.journals_score
    self.save
  end

  def update_scorecard(data_type)
    self.increment_checkin_count(data_type)

    if self.checkin_yesterday?(data_type)
      self.increment_streak_count(data_type)
    else
      self.reset_streak_count(data_type)
    end

    self.update_main_streak_count
    self.update_streak_record(data_type)
    self.update_main_streak_record

    self.set_last_checkin_date(data_type, DateTime.now)

    if perfect_checkin_today?
      self.increment_perfect_checkin_count
      self.set_last_perfect_checkin_date(DateTime.now)
    end

    self.calculate_days_since_signup
    self.set_level_multiplier(data_type)
    self.refresh_scorecard(data_type)
    self.save
  end

  def refresh_scorecard(data_type)
    score = self.calculate_score(data_type)
    self.update_score(data_type, score)
    self.set_total_score
    self.save
  end
end