module UsersHelper
  def login_to_parse
    @parse_user = Parse::User.authenticate("adrian@adriancunanan.com", "ABCvsp0138THR")
  end

  def get_data_count(parse_data_type)
    if parse_data_type == "UserData"
      @parse_user_data_count = Parse::Query.new("UserData").tap do |q|
        q.eq("UserID", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    elsif parse_data_type == "Mood"
      @parse_mood_count = Parse::Query.new("Mood").tap do |q|
        q.eq("user_id", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    elsif parse_data_type == "Sleep"
      @parse_sleep_count = Parse::Query.new("Sleep").tap do |q|
        q.eq("user_id", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    elsif parse_data_type == "SelfCare"
      @parse_self_care_count = Parse::Query.new("SelfCare").tap do |q|
        q.eq("user_id", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    elsif parse_data_type == "Journal"
      @parse_journal_count = Parse::Query.new("Journal").tap do |q|
        q.eq("user_id", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    end 
  end

  def initialize_parse_instance_variables
    @parse_user_datas = []
    @parse_moods = []
    @parse_sleeps = []
    @parse_self_cares = []
    @parse_journals = []
  end

  def extract_parse_data(parse_data_type, user_id, last_object_limit, key_data_count)
    if parse_data_type == "UserData"
      user_data_query = Parse::Query.new("UserData").eq("UserID", user_id).tap do |q|
        q.limit = 100
        q.skip = last_object_limit
      end.get
      if user_data_query != nil
        user_data_query.each do |user_data|
          @parse_user_datas << user_data
        end
      end
      if last_object_limit < @parse_user_data_count["count"]
        extract_parse_data(parse_data_type, user_id, last_object_limit + 100, key_data_count)
      end
    elsif parse_data_type == "Mood"
      parse_moods_query = Parse::Query.new("Mood").eq("user_id", user_id).tap do |q|
        q.limit = 100
        q.skip = last_object_limit
      end.get
      if parse_moods_query != nil
        parse_moods_query.each do |parse_mood|
          @parse_moods << parse_mood
        end
      end
      if last_object_limit < @parse_mood_count["count"]
        extract_parse_data(parse_data_type, user_id, last_object_limit + 100, key_data_count)
      end
    elsif parse_data_type == "Sleep"
      parse_sleeps_query = Parse::Query.new("Sleep").eq("user_id", user_id).tap do |q|
        q.limit = 100
        q.skip = last_object_limit
      end.get
      if parse_sleeps_query != nil
        parse_sleeps_query.each do |parse_sleep|
          @parse_sleeps << parse_sleep
        end
      end
      if last_object_limit < @parse_sleep_count["count"]
        extract_parse_data(parse_data_type, user_id, last_object_limit + 100, key_data_count)
      end
    elsif parse_data_type == "SelfCare"
      parse_self_cares_query = Parse::Query.new("SelfCare").eq("user_id", user_id).tap do |q|
        q.limit = 100
        q.skip = last_object_limit
      end.get
      if parse_self_cares_query != nil
        parse_self_cares_query.each do |parse_self_care|
          @parse_self_cares << parse_self_care
        end
      end
      if last_object_limit < @parse_self_care_count["count"]
        extract_parse_data(parse_data_type, user_id, last_object_limit + 100, key_data_count)
      end
    elsif parse_data_type == "Journal"
      parse_journals_query = Parse::Query.new("Journal").eq("user_id", user_id).tap do |q|
        q.limit = 100
        q.skip = last_object_limit
      end.get
      if parse_journals_query != nil
        parse_journals_query.each do |parse_journal|
          @parse_journals << parse_journal
        end
      end
      if last_object_limit < @parse_journal_count["count"]
        extract_parse_data(parse_data_type, user_id, last_object_limit + 100, key_data_count)
      end
    end
      
    
  end

  def combine_date_and_time(date, time)
    d = date.to_date
    t = Time.parse(time.to_time.to_s)
    dt = (d + t.seconds_since_midnight.seconds).to_datetime
  end

  def find_timestamp(data_type, object_id)
    if data_type == "Mood"
      mood_pointer = Parse::Pointer.new({
        "className" => "Mood",
        "objectId"  => object_id
      })

      @parse_user_datas.each do |user_data|
        if user_data["Mood"] != nil
          if user_data["Mood"].include? mood_pointer
            @user_data = user_data
          end
        end
      end

      @key_data = @parse_moods.detect {|parse_mood| parse_mood["objectId"].include? object_id }

      time = @key_data["timeStamp"].to_datetime.to_s
      time = Time.parse(time).utc
    elsif data_type == "SelfCare"
      self_care_pointer = Parse::Pointer.new({
        "className" => "SelfCare",
        "objectId"  => object_id
      })

      @parse_user_datas.each do |user_data|
        if user_data["SelfCare"] != nil
          if user_data["SelfCare"] == self_care_pointer
            @user_data = user_data
          end
        end
      end

      @key_data = @parse_self_cares.detect {|parse_self_care| parse_self_care["objectId"] == object_id }

      time = @key_data["updatedAt"].to_datetime.to_s
      time = Time.parse(time).utc
    elsif data_type == "Journal"
      journal_pointer = Parse::Pointer.new({
        "className" => "Journal",
        "objectId"  => object_id
      })

      @parse_user_datas.each do |user_data|
        if user_data["Journal"] != nil
          if user_data["Journal"] == journal_pointer
            @user_data = user_data
          end
        end
      end

      @key_data = @parse_journals.detect {|parse_journal| parse_journal["objectId"] == object_id }

      time = @key_data["updatedAt"].to_datetime.to_s
      time = Time.parse(time).utc
    end

    if @user_data == nil || time == nil
      return nil
    else
      date = @user_data["userCreatedDate"].in_time_zone
      @timestamp = combine_date_and_time(date, time)
    end
  end

  def transform_and_load_parse_data(data_type, user_id)
    if data_type == "Mood"
      @parse_moods.each do |parse_mood|
        if !duplicate_entry_exists?(data_type, parse_mood["objectId"])
          mood = Mood.create!(
            :mood_rating => (parse_mood["moodRating"] + 1),
            :anxiety_rating => (parse_mood["anxietyRating"] + 1),
            :irritability_rating => (parse_mood["irritabilityRating"] + 1),
            :user_id => user_id
          )

          find_timestamp("Mood", parse_mood["objectId"])
          next if @timestamp == nil
          mood.timestamp = @timestamp

          mood.created_at = parse_mood["createdAt"]
          mood.updated_at = parse_mood["updatedAt"]
          mood.parse_object_id = parse_mood["objectId"]
          mood.save!
        else
          if duplicate_entry_updated?(data_type, parse_mood["objectId"], parse_mood)
            mood = Mood.where(parse_object_id: parse_mood["objectId"]).first
            mood.mood_rating = (parse_mood["moodRating"] + 1)
            mood.anxiety_rating = (parse_mood["anxietyRating"] + 1)
            mood.irritability_rating = (parse_mood["irritabilityRating"] + 1)

            find_timestamp("Mood", parse_mood["objectId"])
            next if @timestamp == nil
            mood.timestamp = @timestamp

            mood.created_at = parse_mood["createdAt"]
            mood.updated_at = parse_mood["updatedAt"]
            mood.parse_object_id = parse_mood["objectId"]
            mood.save!
          end
        end
      end

    elsif data_type == "Sleep"  
      @parse_sleeps.each do |parse_sleep|
        if !duplicate_entry_exists?(data_type, parse_sleep["objectId"])
          sleep = Sleep.create!(
            :start_time => parse_sleep["startTime"],
            :finish_time => parse_sleep["finishTime"],
            :time => (parse_sleep["finishTime"].to_i - parse_sleep["startTime"].to_i) / 3600,
            :quality => (parse_sleep["quality"] + 1),
            :user_id => user_id
          )

          sleep.created_at = parse_sleep["createdAt"]
          sleep.updated_at = parse_sleep["updatedAt"]
          sleep.parse_object_id = parse_sleep["objectId"]
          sleep.save!
        else
          if duplicate_entry_updated?(data_type, parse_sleep["objectId"], parse_sleep)
            sleep = Sleep.where(parse_object_id: parse_sleep["objectId"]).first

            sleep.start_time = parse_sleep["startTime"]
            sleep.finish_time = parse_sleep["finishTime"]
            sleep.time = (parse_sleep["finishTime"].to_i - parse_sleep["startTime"].to_i) / 3600
            sleep.quality = (parse_sleep["quality"] + 1)

            sleep.created_at = parse_sleep["createdAt"]
            sleep.updated_at = parse_sleep["updatedAt"]
            sleep.parse_object_id = parse_sleep["objectId"]
            sleep.save!
          end
        end
      end

    elsif data_type == "SelfCare"
      @parse_self_cares.each do |parse_self_care|
        if !duplicate_entry_exists?(data_type, parse_self_care["objectId"])
          self_care = SelfCare.create!(
            :counseling => parse_self_care["counseling"],
            :medication => parse_self_care["medication"],
            :meditation => parse_self_care["meditation"],
            :exercise => parse_self_care["exercise"],
            :user_id => user_id
          )

          find_timestamp("SelfCare", parse_self_care["objectId"])
          next if @timestamp == nil
          self_care.timestamp = @timestamp

          self_care.created_at = parse_self_care["createdAt"]
          self_care.updated_at = parse_self_care["updatedAt"]
          self_care.parse_object_id = parse_self_care["objectId"]
          self_care.save!
        else
          if duplicate_entry_updated?(data_type, parse_self_care["objectId"], parse_self_care)
            self_care = SelfCare.where(parse_object_id: parse_self_care["objectId"]).first

            self_care.counseling = parse_self_care["counseling"]
            self_care.medication = parse_self_care["medication"]
            self_care.meditation = parse_self_care["meditation"]
            self_care.exercise = parse_self_care["exercise"]

            find_timestamp("SelfCare", parse_self_care["objectId"])
            next if @timestamp == nil
            self_care.timestamp = @timestamp

            self_care.created_at = parse_self_care["createdAt"]
            self_care.updated_at = parse_self_care["updatedAt"]
            self_care.parse_object_id = parse_self_care["objectId"]
            self_care.save!
          end
        end
      end

    elsif data_type == "Journal"
      @parse_journals.each do |parse_journal|
        if !duplicate_entry_exists?(data_type, parse_journal["objectId"])
          journal = Journal.create!(
            :journal_entry => parse_journal["journalEntry"],
            :user_id => user_id
          )
          find_timestamp("Journal", parse_journal["objectId"])
          next if @timestamp == nil
          journal.timestamp = @timestamp
          journal.created_at = parse_journal["createdAt"]
          journal.updated_at = parse_journal["updatedAt"]
          journal.parse_object_id = parse_journal["objectId"]
          journal.save!
        else
          if duplicate_entry_updated?(data_type, parse_journal["objectId"], parse_journal)
            journal = Journal.where(parse_object_id: parse_journal["objectId"]).first

            journal.journal_entry = parse_journal["journalEntry"]

            find_timestamp("Journal", parse_journal["objectId"])
            next if @timestamp == nil
            journal.timestamp = @timestamp

            journal.created_at = parse_journal["createdAt"]
            journal.updated_at = parse_journal["updatedAt"]
            journal.parse_object_id = parse_journal["objectId"]
            journal.save!
          end
        end
      end
    end
  end

  def etl_for_parse(user_id)
    initialize_parse_instance_variables
    login_to_parse
    if @parse_user != nil
      get_data_count("UserData")
      get_data_count("Mood")
      get_data_count("Sleep")
      get_data_count("SelfCare")
      get_data_count("Journal")

      extract_parse_data("UserData", @parse_user["objectId"], 0, @parse_user_data_count)
      extract_parse_data("Mood", @parse_user["objectId"], 0, @parse_mood_count)
      extract_parse_data("Sleep", @parse_user["objectId"], 0, @parse_sleep_count)
      extract_parse_data("SelfCare", @parse_user["objectId"], 0, @parse_self_care_count)
      extract_parse_data("Journal", @parse_user["objectId"], 0, @parse_journal_count)
      
      transform_and_load_parse_data("Mood", user_id)
      transform_and_load_parse_data("Sleep", user_id)
      transform_and_load_parse_data("SelfCare", user_id)
      transform_and_load_parse_data("Journal", user_id)
    end
  end

  def duplicate_entry_exists?(data_type, parse_object_id)
    if data_type == "Mood"
      duplicate_entry = Mood.where(parse_object_id: parse_object_id).first
    elsif data_type == "Sleep"
      duplicate_entry = Sleep.where(parse_object_id: parse_object_id).first
    elsif data_type == "SelfCare"
      duplicate_entry = SelfCare.where(parse_object_id: parse_object_id).first
    elsif data_type == "Journal"
      duplicate_entry = Journal.where(parse_object_id: parse_object_id).first
    end

    if duplicate_entry == nil
      return false
    else
      return true
    end
  end

  def duplicate_entry_updated?(data_type, parse_object_id, parse_data_entry)
    if data_type == "Mood"
      duplicate_entry = Mood.where(parse_object_id: parse_object_id).first
    elsif data_type == "Sleep"
      duplicate_entry = Sleep.where(parse_object_id: parse_object_id).first
    elsif data_type == "SelfCare"
      duplicate_entry = SelfCare.where(parse_object_id: parse_object_id).first
    elsif data_type == "Journal"
      duplicate_entry = Journal.where(parse_object_id: parse_object_id).first
    end

    if duplicate_entry.updated_at < parse_data_entry["updatedAt"]
      return true
    else
      return false
    end
  end
end
