class Scorecard < ActiveRecord::Base
  belongs_to :user

  validates :checkin_goal, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 7}

  after_initialize :init

  def init
    self.checkin_count ||= 0
    self.perfect_checkin_count ||= 0
    self.streak_count ||= 0
    self.moods_score ||= 0
    self.sleeps_score ||= 0
    self.self_cares_score ||= 0
    self.journals_score ||= 0
    self.total_score ||= 0
    self.streak_record ||= 0
    self.multiplier ||= 1
    self.days_since_signup ||= 0
    self.mood_checkin_count ||= 0
    self.mood_streak_count ||= 0
    self.mood_streak_record ||= 0
    self.mood_multiplier ||= 1
    self.sleep_checkin_count ||= 0
    self.sleep_streak_count ||= 0
    self.sleep_streak_record ||= 0
    self.sleep_multiplier ||= 1
    self.self_care_checkin_count ||= 0
    self.self_care_streak_count ||= 0
    self.self_care_streak_record ||= 0
    self.self_care_multiplier ||= 1
    self.journal_checkin_count ||= 0
    self.journal_streak_count ||= 0
    self.journal_streak_record ||= 0
    self.journal_multiplier ||= 1
    self.checkin_goal ||= 4
    self.checkins_to_reach_goal ||= 4
  end

  def calculate_checkin_count
    self.checkin_count = self.mood_checkin_count + self.sleep_checkin_count + self.self_care_checkin_count + self.journal_checkin_count
    self.save
  end

  def calculate_next_move_value(data_type)
    signup_bonus = 0.1

    if data_type == 'moods'
      1 + (((self.days_since_signup * signup_bonus ) + 1 ) * self.mood_multiplier).round
    elsif data_type == 'sleeps'
      1 + (((self.days_since_signup * signup_bonus ) + 1 ) * self.sleep_multiplier).round
    elsif data_type == 'self_cares'
      1 + (((self.days_since_signup * signup_bonus ) +1 )  * self.self_care_multiplier).round
    elsif data_type == 'journals'
      1 + (((self.days_since_signup * signup_bonus ) + 1 ) * self.journal_multiplier).round
    end
  end

  def calculate_score(data_type)
    if data_type == 'moods'
      self.moods_score = self.moods_score + calculate_next_move_value(data_type)
      self.save
    elsif data_type == 'sleeps'
      self.sleeps_score = self.sleeps_score + calculate_next_move_value(data_type)
      self.save
    elsif data_type == 'self_cares'
      self.self_cares_score = self.self_cares_score + calculate_next_move_value(data_type)
      self.save
    elsif data_type == 'journals'
      self.journals_score = self.journals_score + calculate_next_move_value(data_type)
      self.save
    end
  end

  def calculate_total_score
    self.total_score = self.moods_score + self.sleeps_score + self.self_cares_score + self.journals_score
    self.save
  end

  def current_streak_count_is_zero?(data_type)
    ((data_type == 'moods' && self.mood_streak_count == 0) ||
      (data_type == 'sleeps' && self.sleep_streak_count == 0) ||
      (data_type == 'self_cares' && self.self_care_streak_count == 0) ||
      (data_type == 'journals' && self.journal_streak_count == 0))
  end

  def increment_streak?(data_type, checkin_datetime)
    ((current_streak_count_is_zero?(data_type) || checkin_day_before?(data_type, checkin_datetime)) &&
      ((get_last_entry_date(data_type).in_time_zone.to_date == checkin_datetime.in_time_zone.to_date) &&
        first_checkin_entered_on_date?(data_type, checkin_datetime.to_date)))
  end

  def reset_streak?(data_type, checkin_datetime)
    last_entry_date = self.get_last_entry_date(data_type)

    if last_entry_date != nil
      last_entry_date = last_entry_date.in_time_zone.to_date
    end

    !self.checkin_day_before?(data_type, checkin_datetime) && (last_entry_date != Time.zone.now.to_date)
  end

  def decrement_multiplier?(data_type, decrement_value)
    ((data_type == 'moods' && ((self.mood_multiplier - decrement_value) >= 1)) ||
      (data_type == 'sleeps' && ((self.sleep_multiplier - decrement_value) >= 1)) ||
      (data_type == 'self_cares' && ((self.self_care_multiplier - decrement_value) >= 1)) ||
      (data_type == 'journals' && ((self.journal_multiplier - decrement_value) >= 1)))
  end

  def checkin_day_before?(data_type, checkin_datetime)
    yesterdays_date = checkin_datetime.in_time_zone.to_date - 1.day
    data_count_for_yesterday = 0
    user_datas = []

    if data_type != 'sleeps'
      if data_type == 'moods'
        user_datas = Mood.where(user_id: self.user_id)
      elsif data_type == 'self_cares'
        user_datas = SelfCare.where(user_id: self.user_id)

      elsif data_type == 'journals'
        user_datas = Journal.where(user_id: self.user_id)
      end

      user_datas.each do |data|
        if data.timestamp.to_date == yesterdays_date
          data_count_for_yesterday += 1
        end
      end
    elsif data_type == 'sleeps'
      user_datas = Sleep.where(user_id: self.user_id)

      user_datas.each do |data|
        if data.finish_time.to_date == yesterdays_date
          data_count_for_yesterday += 1
        end
      end
    end

    data_count_for_yesterday > 0
  end

  def perfect_checkin_on_date?(date_to_check)
    user_moods = Mood.where(user_id: self.user_id)
    user_sleeps = Sleep.where(user_id: self.user_id)
    user_self_cares = SelfCare.where(user_id: self.user_id)
    user_journals = Journal.where(user_id: self.user_id)

    mood_entries_for_date = []
    sleep_entries_for_date = []
    self_care_entries_for_date = []
    journal_entries_for_date = []

    if !user_moods.empty?
      user_moods.each do |mood|
        if mood.timestamp.to_date == date_to_check.to_date
          mood_entries_for_date << mood
        end
      end
      if mood_entries_for_date.empty?
        mood_checkin_for_date = false
      else
        mood_checkin_for_date = true
      end
    else
      mood_checkin_for_date = false
    end

    if !user_sleeps.empty?
      user_sleeps.each do |sleep|
        if sleep.finish_time.to_date == date_to_check.to_date
          sleep_entries_for_date << sleep
        end
      end
      if sleep_entries_for_date.empty?
        sleep_checkin_for_date = false
      else
        sleep_checkin_for_date = true
      end
    else
      sleep_checkin_for_date = false
    end

    if !user_self_cares.empty?
      user_self_cares.each do |self_care|
        if self_care.timestamp.to_date == date_to_check.to_date
          self_care_entries_for_date << self_care
        end
      end
      if self_care_entries_for_date.empty?
        self_care_checkin_for_date = false
      else
        self_care_checkin_for_date = true
      end
    else
      self_care_checkin_for_date = false
    end

    if !user_journals.empty?
      user_journals.each do |journal|
        if journal.timestamp.to_date == date_to_check.to_date
          journal_entries_for_date << journal
        end
      end
      if journal_entries_for_date.empty?
        journal_checkin_for_date = false
      else
        journal_checkin_for_date = true
      end
    else
      journal_checkin_for_date = false
    end

    return mood_checkin_for_date && sleep_checkin_for_date && self_care_checkin_for_date && journal_checkin_for_date
  end

  def first_perfect_checkin?(date_to_check)
    if self.last_perfect_checkin_date == nil
      true
    else
      date_to_check.in_time_zone.to_date != self.last_perfect_checkin_date.in_time_zone.to_date
    end
  end

  def is_last_entry_day_before?(data_type, checkin_datetime)
    last_entry_date = get_last_entry_date(data_type)
    last_entry_date.in_time_zone.to_date == checkin_datetime.in_time_zone.to_date - 1.day
  end

  def first_checkin_entered_on_date?(data_type, date_to_check)
    users_data = []
    data_count_for_date = 0

    if data_type != 'sleeps'
      if data_type == 'moods'
        users_data = Mood.where(user_id: self.user_id)
      elsif data_type == 'self_cares'
        users_data = SelfCare.where(user_id: self.user_id)
      elsif data_type == 'journals'
        users_data = Journal.where(user_id: self.user_id)
      end

      users_data.each do |data|
        if data.timestamp.in_time_zone.to_date == date_to_check.in_time_zone.to_date
          data_count_for_date += 1
        end
      end
    elsif data_type == 'sleeps'
      users_data = Sleep.where(user_id: self.user_id)
      users_data.each do |data|
        if data.finish_time.in_time_zone.to_date == date_to_check.in_time_zone.to_date
          data_count_for_date += 1
        end
      end
    end

    data_count_for_date == 1
  end

  def get_checkin_count(data_type)
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

  def get_streak_count(data_type)
    if data_type == 'moods'
      self.mood_streak_count
    elsif data_type == 'sleeps'
      self.sleep_streak_count
    elsif data_type == 'self_cares'
      self_care_streak_count
    elsif data_type == 'journals'
      journal_streak_count
    end
  end

  def get_streak_record(data_type)
    if data_type == 'moods'
      self.mood_streak_record
    elsif data_type == 'sleeps'
      self.sleep_streak_record
    elsif data_type == 'self_cares'
      self_care_streak_record
    elsif data_type == 'journals'
      journal_streak_record
    end
  end

  def get_last_entry_date(data_type)
    if data_type == 'moods'
      last_entry_date = Mood.where(user_id: self.user_id).order( 'timestamp ASC' ).last
    elsif data_type == 'sleeps'
      last_entry_date = Sleep.where(user_id: self.user_id).order( 'finish_time ASC' ).last
    elsif data_type == 'self_cares'
      last_entry_date = SelfCare.where(user_id: self.user_id).order( 'timestamp ASC' ).last
    elsif data_type == 'journals'
      last_entry_date = Journal.where(user_id: self.user_id).order( 'timestamp ASC' ).last
    end

    if last_entry_date != nil
      if data_type == 'sleeps'
        last_entry_date = last_entry_date.finish_time
      else
        last_entry_date = last_entry_date.timestamp
      end
    end

    return last_entry_date
  end

  def set_last_perfect_checkin_date(checkin_datetime)
    self.update_attribute(:last_perfect_checkin_date, checkin_datetime)
  end

  def set_last_checkin_date(data_type, checkin_datetime)
    if data_type == 'moods'
      self.update_attribute(:mood_last_checkin_date, checkin_datetime)
    elsif data_type == 'sleeps'
      self.update_attribute(:sleep_last_checkin_date, checkin_datetime)
    elsif data_type == 'self_cares'
      self.update_attribute(:self_care_last_checkin_date, checkin_datetime)
    elsif data_type == 'journals'
      self.update_attribute(:journal_last_checkin_date, checkin_datetime)
    end
    self.update_attribute(:last_checkin_date, checkin_datetime)
    self.save
  end

  def set_days_since_signup(current_datetime)
    user_signup_date = User.find(self.user_id).created_at_before_type_cast.in_time_zone.to_date
    days_since_signup = (current_datetime.in_time_zone.to_date - user_signup_date).to_i
    self.days_since_signup = days_since_signup
    self.save
  end

  def set_checkin_flags
    # Clear Flags
    self.checkin_sunday = false
    self.checkin_monday = false
    self.checkin_tuesday = false
    self.checkin_wednesday = false
    self.checkin_thursday = false
    self.checkin_friday = false
    self.checkin_saturday = false

    # Load current week data
    moods_this_week = Mood.where(user_id: self.user_id).where(:timestamp => DATE_RANGE_THIS_WEEK)
    sleeps_this_week = Sleep.where(user_id: self.user_id).where(:finish_time => DATE_RANGE_THIS_WEEK)
    self_cares_this_week = SelfCare.where(user_id: self.user_id).where(:timestamp => DATE_RANGE_THIS_WEEK)
    journals_this_week = Journal.where(user_id: self.user_id).where(:timestamp => DATE_RANGE_THIS_WEEK)

    # Check flag if timestamp present
    moods_this_week.each do |mood|
      if mood.timestamp.sunday?
        self.checkin_sunday = true
      elsif mood.timestamp.monday?
        self.checkin_monday = true
      elsif mood.timestamp.tuesday?
        self.checkin_tuesday = true
      elsif mood.timestamp.wednesday?
        self.checkin_wednesday = true
      elsif mood.timestamp.thursday?
        self.checkin_thursday = true
      elsif mood.timestamp.friday?
        self.checkin_friday = true
      elsif mood.timestamp.saturday?
        self.checkin_saturday = true
      end
    end

    sleeps_this_week.each do |sleep|
      if sleep.finish_time.sunday?
        self.checkin_sunday = true
      elsif sleep.finish_time.monday?
        self.checkin_monday = true
      elsif sleep.finish_time.tuesday?
        self.checkin_tuesday = true
      elsif sleep.finish_time.wednesday?
        self.checkin_wednesday = true
      elsif sleep.finish_time.thursday?
        self.checkin_thursday = true
      elsif sleep.finish_time.friday?
        self.checkin_friday = true
      elsif sleep.finish_time.saturday?
        self.checkin_saturday = true
      end
    end

    self_cares_this_week.each do |self_care|
      if self_care.timestamp.sunday?
        self.checkin_sunday = true
      elsif self_care.timestamp.monday?
        self.checkin_monday = true
      elsif self_care.timestamp.tuesday?
        self.checkin_tuesday = true
      elsif self_care.timestamp.wednesday?
        self.checkin_wednesday = true
      elsif self_care.timestamp.thursday?
        self.checkin_thursday = true
      elsif self_care.timestamp.friday?
        self.checkin_friday = true
      elsif self_care.timestamp.saturday?
        self.checkin_saturday = true
      end
    end

    journals_this_week.each do |journal|
      if journal.timestamp.sunday?
        self.checkin_sunday = true
      elsif journal.timestamp.monday?
        self.checkin_monday = true
      elsif journal.timestamp.tuesday?
        self.checkin_tuesday = true
      elsif journal.timestamp.wednesday?
        self.checkin_wednesday = true
      elsif journal.timestamp.thursday?
        self.checkin_thursday = true
      elsif journal.timestamp.friday?
        self.checkin_friday = true
      elsif journal.timestamp.saturday?
        self.checkin_saturday = true
      end
    end

    self.save
  end

  def set_checkins_to_reach_goal
    checkins_to_reach_goal = self.checkin_goal

    if self.checkin_sunday == true
      checkins_to_reach_goal -= 1
    end

    if self.checkin_monday == true
      checkins_to_reach_goal -= 1
    end

    if self.checkin_tuesday == true
      checkins_to_reach_goal -= 1
    end

    if self.checkin_wednesday == true
      checkins_to_reach_goal -= 1
    end

    if self.checkin_thursday == true
      checkins_to_reach_goal -= 1
    end

    if self.checkin_friday == true
      checkins_to_reach_goal -= 1
    end

    if self.checkin_saturday == true
      checkins_to_reach_goal -= 1
    end

    if checkins_to_reach_goal < 0
      checkins_to_reach_goal = 0
    end

    self.checkins_to_reach_goal = checkins_to_reach_goal
    self.save
  end

  def set_streak_count(data_type, count_value)
    if data_type == 'moods'
      self.mood_streak_count = count_value
    elsif data_type == 'sleeps'
      self.sleep_streak_count = count_value
    elsif data_type == 'self_cares'
      self.self_care_streak_count = count_value
    elsif data_type == 'journals'
      self.journal_streak_count = count_value
    end
    self.save
  end

  def set_multiplier(data_type, new_value)
    if data_type == 'moods'
      self.mood_multiplier = new_value
    elsif data_type == 'sleeps'
      self.sleep_multiplier = new_value
    elsif data_type == 'self_cares'
      self.self_care_multiplier = new_value
    elsif data_type == 'journals'
      self.journal_multiplier = new_value
    end
    self.save
  end

  def set_streak_record(data_type, streak_value)
    if data_type == 'moods'
      self.mood_streak_record = streak_value
    elsif data_type == 'sleeps'
      self.sleep_streak_record = streak_value
    elsif data_type == 'self_cares'
      self.self_care_streak_record = streak_value
    elsif data_type == 'journals'
      self.journal_streak_record = streak_value
    end
    self.save
  end

  def increment_checkin_count(data_type, increment_value)
    if data_type == 'moods'
      self.mood_checkin_count += increment_value
    elsif data_type == 'sleeps'
      self.sleep_checkin_count += increment_value
    elsif data_type == 'self_cares'
      self.self_care_checkin_count += increment_value
    elsif data_type == 'journals'
      self.journal_checkin_count += increment_value
    end
    self.save
  end

  def increment_perfect_checkin_count(increment_value)
    self.perfect_checkin_count += increment_value
    self.save
  end

  def increment_streak_count(data_type, increment_value)
    if data_type == 'moods'
      self.mood_streak_count += increment_value
    elsif data_type == 'sleeps'
      self.sleep_streak_count += increment_value
    elsif data_type == 'self_cares'
      self.self_care_streak_count += increment_value
    elsif data_type == 'journals'
      self.journal_streak_count += increment_value
    end
    self.save
  end

  def increment_streak_record(data_type, increment_value)
    if data_type == 'moods'
      self.mood_streak_record += increment_value
    elsif data_type == 'sleeps'
      self.sleep_streak_record += increment_value
    elsif data_type == 'self_cares'
      self.self_care_streak_record += increment_value
    elsif data_type == 'journals'
      self.journal_streak_record += increment_value
    end
    self.save
  end

  def increment_multiplier(data_type, increment)
    if data_type == 'moods'
      self.mood_multiplier += increment
    elsif data_type == 'sleeps'
      self.sleep_multiplier += increment
    elsif data_type == 'self_cares'
      self.self_care_multiplier += increment
    elsif data_type == 'journals'
      self.journal_multiplier += increment
    end
    self.save
  end

  def decrement_multiplier(data_type)
    decrement_value = -0.15

    if decrement_multiplier?(data_type,decrement_value)
      increment_multiplier(data_type, decrement_value)
    end
  end

  def reset_checkin_count(data_type)
    if data_type == 'moods'
      self.mood_checkin_count = 0
    elsif data_type == 'sleeps'
      self.sleep_checkin_count = 0
    elsif data_type == 'self_cares'
      self.self_care_checkin_count = 0
    elsif data_type == 'journals'
      self.journal_checkin_count = 0
    end
    self.save
  end

  def reset_streak_count(data_type)
    self.set_streak_count(data_type, 0)
  end

  def reset_multiplier(data_type)
    self.set_multiplier(data_type, 0)
  end

  def update_main_multiplier
    multipliers = []
    multipliers.push(self.mood_multiplier)
    multipliers.push(self.sleep_multiplier)
    multipliers.push(self.self_care_multiplier)
    multipliers.push(self.journal_multiplier)
    self.multiplier = multipliers.max
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

  def update_goals
    self.set_checkin_flags
    self.set_checkins_to_reach_goal
  end

  def update_streak_metrics(update_datetime)
    key_data_types = ['moods', 'sleeps', 'self_cares', 'journals']

    key_data_types.each do |data_type|
      if self.reset_streak?(data_type, update_datetime)
        self.reset_streak_count(data_type)
        self.reset_multiplier(data_type)
      end
    end
  end

  def update_streak_record(data_type)
    if self.get_streak_count(data_type) >= self.get_streak_record(data_type)
      self.set_streak_record(data_type, self.get_streak_count(data_type))
    end
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

  def update_scorecard(data_type, checkin_datetime)
    self.update_streak_metrics(checkin_datetime)

    if self.increment_streak?(data_type, checkin_datetime)
      self.increment_streak_count(data_type, 1)
      self.update_main_streak_count
      self.increment_multiplier(data_type, 1)
      self.update_main_multiplier
      self.update_streak_record(data_type)
      self.update_main_streak_record
    end

    if perfect_checkin_on_date?(checkin_datetime)
      if first_perfect_checkin?(checkin_datetime)
        self.increment_perfect_checkin_count(1)
        self.set_last_perfect_checkin_date(checkin_datetime)
      end
    end

    self.increment_checkin_count(data_type, 1)
    self.set_last_checkin_date(data_type, checkin_datetime)

    self.set_days_since_signup(checkin_datetime)
    self.calculate_score(data_type)

    self.refresh_scorecard(checkin_datetime)
    self.save
  end

  def refresh_scorecard(refresh_datetime)
    self.calculate_checkin_count
    self.update_streak_metrics(refresh_datetime)
    self.update_goals
    self.calculate_total_score
    self.save
  end
end