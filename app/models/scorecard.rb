class Scorecard < ActiveRecord::Base
  include ApplicationHelper

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
    self.mood_base_value ||= 1
    self.mood_base_perk_register ||= 0
    self.mood_multiplier ||= 1
    self.mood_multiplier_perk_register ||= 0
    self.mood_streak_count ||= 0
    self.mood_streak_base_value ||= 1
    self.mood_streak_perk_register ||= 0
    self.mood_streak_record ||= 0
    self.mood_checkin_count ||= 0
    self.sleep_base_value ||= 1
    self.sleep_base_perk_register ||= 0
    self.sleep_multiplier ||= 1
    self.sleep_multiplier_perk_register ||= 0
    self.sleep_streak_count ||= 0
    self.sleep_streak_base_value ||= 1
    self.sleep_streak_perk_register ||= 0
    self.sleep_streak_record ||= 0
    self.sleep_checkin_count ||= 0
    self.self_care_base_value ||= 1
    self.self_care_base_perk_register ||= 0
    self.self_care_multiplier ||= 1
    self.self_care_multiplier_perk_register ||= 0
    self.self_care_streak_count ||= 0
    self.self_care_streak_base_value ||= 1
    self.self_care_streak_perk_register ||= 0
    self.self_care_streak_record ||= 0
    self.self_care_checkin_count ||= 0
    self.journal_base_value ||= 1
    self.journal_base_perk_register ||= 0
    self.journal_multiplier ||= 1
    self.journal_multiplier_perk_register ||= 0
    self.journal_streak_count ||= 0
    self.journal_streak_base_value ||= 1
    self.journal_streak_perk_register ||= 0
    self.journal_streak_record ||= 0
    self.journal_checkin_count ||= 0
    self.checkin_goal ||= 4
    self.checkins_to_reach_goal ||= 4
  end

  def calculate_checkin_count
    self.checkin_count = self.mood_checkin_count + self.sleep_checkin_count + self.self_care_checkin_count + self.journal_checkin_count
  end

  def calculate_base_value(data_type)
    if data_type == 'moods'
      mood_base_value + (MOOD_BASE_PERK_VALUE * mood_base_perk_register)
    elsif data_type == 'sleeps'
      sleep_base_value + (SLEEP_BASE_PERK_VALUE * sleep_base_perk_register)
    elsif data_type == 'self_cares'
      self_care_base_value + (SELFCARE_BASE_PERK_VALUE * self_care_base_perk_register)
    elsif data_type == 'journals'
      journal_base_value + (JOURNAL_BASE_PERK_VALUE * journal_base_perk_register)
    end
  end

  def calculate_multiplier(data_type)
    if data_type == 'moods'
      mood_multiplier + (MOOD_MULTIPLIER_PERK_VALUE * mood_multiplier_perk_register)
    elsif data_type == 'sleeps'
      sleep_multiplier + (SLEEP_MULTIPLIER_PERK_VALUE * sleep_multiplier_perk_register)
    elsif data_type == 'self_cares'
      self_care_multiplier + (SELFCARE_MULTIPLIER_PERK_VALUE * self_care_multiplier_perk_register)
    elsif data_type == 'journals'
      journal_multiplier + (JOURNAL_MULTIPLIER_PERK_VALUE * journal_multiplier_perk_register)
    end
  end

  def calculate_streak_base_value(data_type)
    if data_type == 'moods'
      mood_streak_base_value + (MOOD_STREAK_PERK_VALUE * mood_streak_perk_register)
    elsif data_type == 'sleeps'
      sleep_streak_base_value + (SLEEP_STREAK_PERK_VALUE * sleep_streak_perk_register)
    elsif data_type == 'self_cares'
      self_care_streak_base_value + (SELFCARE_STREAK_PERK_VALUE * self_care_streak_perk_register)
    elsif data_type == 'journals'
      journal_streak_base_value + (JOURNAL_STREAK_PERK_VALUE * journal_streak_perk_register)
    end
  end

  def calculate_move_value(data_type)
    (calculate_base_value(data_type) * calculate_multiplier(data_type)) + ((calculate_streak_base_value(data_type)) * get_streak_count(data_type))
  end

  def calculate_score(data_type)
    get_score(data_type) + calculate_move_value(data_type)
  end

  def calculate_total_score
    self.total_score = self.moods_score + self.sleeps_score + self.self_cares_score + self.journals_score
  end

  def calculate_streak_count(data_type, streak_datetime)
    # Initialize vars
    user_data_to_streakdatetime = []
    last_checked_date = nil
    streak_count = 0

    # Get User Data for User
    user_data = get_user_data(data_type, 'desc')

    # Remove data after streak_datetime
    user_data.each do |data|
      if data_type == 'sleeps'
        current_checkin_date = data.finish_time.to_date
      else
        current_checkin_date = data.timestamp.to_date
      end

      if current_checkin_date <= streak_datetime
        user_data_to_streakdatetime << data
      end
    end

    # If data set is not empty then compare latest entry with next entry
    if !user_data_to_streakdatetime.empty?
      if data_type == 'sleeps'
        last_checked_date = user_data_to_streakdatetime.first.finish_time.to_date
      else
        last_checked_date = user_data_to_streakdatetime.first.timestamp.to_date
      end
      date_before_last_checked_date = (last_checked_date - 1.day).to_date
    else
      return 0
    end

    if last_checked_date != streak_datetime.to_date
      return 0
    end

    user_data_to_streakdatetime.each do |data|
      if data_type == 'sleeps'
        data_checkin_date = data.finish_time.to_date
      else
        data_checkin_date = data.timestamp.to_date
      end

      if data_checkin_date == last_checked_date
        streak_count = streak_count
      else
        if data_checkin_date == date_before_last_checked_date
          streak_count += 1
        elsif data_checkin_date != date_before_last_checked_date
          return streak_count
        end
      end

      last_checked_date = data_checkin_date

      date_before_last_checked_date = (last_checked_date - 1.day).to_date
    end

    return streak_count
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

  def get_user_data(data_type, order)
    if order == 'asc'
      if data_type == 'moods'
        Mood.where(user_id: self.user_id).order( 'timestamp ASC' )
      elsif data_type == 'sleeps'
        Sleep.where(user_id: self.user_id).order( 'finish_time ASC' )
      elsif data_type == 'self_cares'
        SelfCare.where(user_id: self.user_id).order( 'timestamp ASC' )
      elsif data_type == 'journals'
        Journal.where(user_id: self.user_id).order( 'timestamp ASC' )
      end
    elsif order == 'desc'
      if data_type == 'moods'
        Mood.where(user_id: self.user_id).order( 'timestamp DESC' )
      elsif data_type == 'sleeps'
        Sleep.where(user_id: self.user_id).order( 'finish_time DESC' )
      elsif data_type == 'self_cares'
        SelfCare.where(user_id: self.user_id).order( 'timestamp DESC' )
      elsif data_type == 'journals'
        Journal.where(user_id: self.user_id).order( 'timestamp DESC' )
      end
    end
  end

  def get_score(data_type)
    if data_type == 'moods'
      self.moods_score
    elsif data_type == 'sleeps'
      self.sleeps_score
    elsif data_type == 'self_cares'
      self.self_cares_score
    elsif data_type == 'journals'
      self.journals_score
    end
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
    last_entry_data = get_user_data(data_type, 'asc').last

    if last_entry_data != nil
      if data_type == 'sleeps'
        last_entry_date = last_entry_data.finish_time
      else
        last_entry_date = last_entry_data.timestamp
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

    if self.last_checkin_date.nil?
      self.update_attribute(:last_checkin_date, checkin_datetime)
    else
      if self.last_checkin_date < checkin_datetime
        self.update_attribute(:last_checkin_date, checkin_datetime)
      end
    end

    self.save
  end

  def set_days_since_signup(current_datetime)
    user_signup_date = User.find(self.user_id).created_at_before_type_cast.in_time_zone.to_date
    days_since_signup = (current_datetime.in_time_zone.to_date - user_signup_date).to_i
    self.days_since_signup = days_since_signup
    self.save
  end

  def set_checkin_flags(time_period)
    # Clear Flags
    self.checkin_sunday = false
    self.checkin_monday = false
    self.checkin_tuesday = false
    self.checkin_wednesday = false
    self.checkin_thursday = false
    self.checkin_friday = false
    self.checkin_saturday = false

    # Load current week data
    moods_this_week = Mood.where(user_id: self.user_id).where(:timestamp => time_period)
    sleeps_this_week = Sleep.where(user_id: self.user_id).where(:finish_time => time_period)
    self_cares_this_week = SelfCare.where(user_id: self.user_id).where(:timestamp => time_period)
    journals_this_week = Journal.where(user_id: self.user_id).where(:timestamp => time_period)

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

  def set_base_value(data_type, new_value)
    if data_type == 'moods'
      self.mood_base_value = new_value
    elsif data_type == 'sleeps'
      self.sleep_base_value = new_value
    elsif data_type == 'self_cares'
      self.self_care_base_value = new_value
    elsif data_type == 'journals'
      self.journal_base_value = new_value
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

  def set_streak_base_value(data_type, new_value)
    if data_type == 'moods'
      self.mood_streak_base_value = new_value
    elsif data_type == 'sleeps'
      self.sleep_streak_base_value = new_value
    elsif data_type == 'self_cares'
      self.self_care_streak_base_value = new_value
    elsif data_type == 'journals'
      self.journal_streak_base_value = new_value
    end
    self.save
  end

  def set_score(data_type, new_value)
    if data_type == 'moods'
      self.moods_score = new_value
    elsif data_type == 'sleeps'
      self.sleeps_score = new_value
    elsif data_type == 'self_cares'
      self.self_cares_score = new_value
    elsif data_type == 'journals'
      self.journals_score = new_value
    end
    self.save
  end

  def set_total_score(new_value)
    self.total_score = new_value
    self.save
  end

  def set_checkin_count(new_value)
    self.checkin_count = new_value
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
    self.set_checkin_flags(date_range_for('this_week'))
    self.set_checkins_to_reach_goal
  end

  def update_streak_metrics(update_datetime)
    key_data_types = ['moods', 'sleeps', 'self_cares', 'journals']

    key_data_types.each do |data_type|
      self.set_streak_count(data_type, self.calculate_streak_count(data_type, update_datetime))
      self.update_streak_record(data_type)
    end
    self.update_main_streak_count
    self.update_main_streak_record
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

  def update_score(data_type)
    set_score(data_type, calculate_score(data_type))
  end

  def update_checkin_count
    set_checkin_count(calculate_checkin_count)
  end

  def update_total_score
    set_total_score(calculate_total_score)
  end

  def update_scorecard(data_type, checkin_datetime)
    self.update_streak_metrics(checkin_datetime)

    if perfect_checkin_on_date?(checkin_datetime)
      if first_perfect_checkin?(checkin_datetime)
        self.increment_perfect_checkin_count(1)
        self.set_last_perfect_checkin_date(checkin_datetime)
      end
    end

    self.increment_checkin_count(data_type, 1)
    self.set_last_checkin_date(data_type, checkin_datetime)
    self.set_days_since_signup(Time.zone.now)
    self.update_score(data_type)
    self.refresh_scorecard(checkin_datetime)
    self.save
  end

  def refresh_scorecard(refresh_datetime)
    self.update_streak_metrics(refresh_datetime)
    self.update_checkin_count
    self.update_goals
    self.update_total_score
    self.save
  end

  def nilify_attributes!(except = nil)
    except ||= %w{id created_at updated_at user_id}
    attribute_names.reject { |attr| except.include?(attr) }.each { |attr| self[attr] = nil }
  end

  def rebase
    user_data = []

    self.nilify_attributes!
    self.init

    key_data_types = ['moods', 'sleeps', 'self_cares', 'journals']

    key_data_types.each do |data_type|
      user_data = self.get_user_data(data_type, 'asc')

      user_data.each do |data|
        if data_type == 'sleeps'
          self.update_scorecard(data_type, data.finish_time)
        else
          self.update_scorecard(data_type, data.timestamp)
        end
      end
    end

    self.set_days_since_signup(Time.zone.now)
  end
end