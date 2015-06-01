class Scorecard < ActiveRecord::Base
	belongs_to :user

  after_initialize :init

  def init
    self.checkin_count  ||= 0
    self.perfect_checkin_count ||= 0
    self.streak_count ||= 0
    self.streak_record ||= 0
    self.level_multiplier ||= 1
  end

  def increment_checkin_count
    self.checkin_count += 1
    self.save
  end

  def checkin_yesterday?
    return self.last_checkin_date == DateTime.yesterday
  end

  def increment_perfect_checkin_count
    self.perfect_checkin_count += 1
    self.save
  end

  def perfect_checkin_today?
    todays_date = DateTime.now.to_date

    last_mood_entry = Mood.where(user_id: self.user_id)
    if last_mood_entry == nil
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

  def set_last_checkin_date(checkin_date)
    self.update_attribute(:last_checkin_date, checkin_date)
    self.save
  end

  def increment_streak_count
    self.streak_count += 1
    self.save
  end

  def reset_streak_count
    self.streak_count = 0
    self.save
  end

  def update_streak_record
    if self.streak_record >= self.streak_count
      self.streak_record += 1
    end
    self.save
  end

  def calculate_days_since_signup
    user_signup_date = User.find(self.user_id).created_at_before_type_cast.to_datetime
    days_since_signup = ( DateTime.now - user_signup_date).to_i
    self.days_since_signup = days_since_signup
    self.save
  end

  def set_level_multiplier
    if self.checkin_count < 7
      self.level_multiplier = 1
    elsif self.checkin_count >= 7
      self.level_multiplier = 2
    elsif self.checkin_count >= 14
      self.level_multiplier = 4
    elsif self.checkin_count >= 21
      self.level_multiplier = 6
    elsif self.checkin_count >= 90
      self.level_multiplier = 8
    elsif self.checkin_count >= 120
      self.level_multiplier = 10
    elsif self.checkin_count >= 365
      self.level_multiplier = 12
    end
    self.save 
  end

  def calculate_score
    return (self.checkin_count + self.days_since_signup) * (self.streak_count + self.streak_record) * self.level_multiplier
  end

  def update_score(data_type, new_score)
    if data_type == 'moods'
      self.moods_score = new_score
    elsif data_type == 'sleeps'
      self.sleeps_score = new_score
    elsif data_type == 'self_cares'
      self.self_cares_score = new_score
    elsif data_type == 'journals'
      self.journals_score = new_score
    end
    self.save
  end

  def update_scorecard(data_type)
    self.increment_checkin_count

    self.set_last_checkin_date(DateTime.now)

    if perfect_checkin_today?
      self.increment_perfect_checkin_count
    end

    if self.checkin_yesterday?
      self.increment_streak_count
    else
      self.reset_streak_count
    end

    self.update_streak_record

    self.calculate_days_since_signup

    self.set_level_multiplier

    score = calculate_score

    self.update_score(data_type, score)
  end
end
