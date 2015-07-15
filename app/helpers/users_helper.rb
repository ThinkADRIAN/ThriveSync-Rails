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
      user_data_query = Parse::Query.new("UserData").eq("user_id", user_id).tap do |q|
        q.limit = 100
        q.skip = last_object_limit
      end.get
      @parse_user_datas << user_data_query
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
    end
      
    if last_object_limit < @parse_user_data_count["count"]
      extract_parse_data(parse_data_type, user_id, last_object_limit + 100, key_data_count)
    end
  end

  def combine_date_and_time(date, time)
    d = date.to_date
    t = time.to_time
    dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)
  end

  def get_key_data_datetime_from_user_data(data_type, object_id)
    if data_type == "Mood" 
      mood_pointer = Parse::Pointer.new({
        "className" => "Mood",
        "objectId"  => object_id
      })
      user_data = Parse::Query.new("UserData").eq("Mood", mood_pointer).get
      key_data = Parse::Query.new("Mood").eq("objectId", object_id).get
      time = key_data.first["timeStamp"].to_datetime.strftime("%I:%M %P")
    elsif data_type == "SelfCare"
      self_care_pointer = Parse::Pointer.new({
        "className" => "SelfCare",
        "objectId"  => object_id
      })
      user_data = Parse::Query.new("UserData").eq("SelfCare", self_care_pointer).get
      key_data = Parse::Query.new("SelfCare").eq("objectId", object_id).get
      time = key_data.first["updatedAt"].to_datetime.strftime("%I:%M %P")
    elsif data_type == "Journal"
      journal_pointer = Parse::Pointer.new({
        "className" => "Journal",
        "objectId"  => object_id
      })
      user_data = Parse::Query.new("UserData").eq("Journal", journal_pointer).get
      key_data = Parse::Query.new("Journal").eq("objectId", object_id).get
      time = key_data.first["updatedAt"].to_datetime.strftime("%I:%M %P")
    end

    date = user_data.first["userCreatedDate"]
    combine_date_and_time(date, time)
  end

=begin
  def extract_parse_data
    @parse_client = $parse_client
    @mood_query = @parse_client.query("Mood").eq("user_id", @parse_user.id).get
    @sleep_query = @parse_client.query("Sleep").eq("user_id", @parse_user.id).get
    @self_care_query = @parse_client.query("SelfCare").eq("user_id", @parse_user.id).get
    @journal_query = @parse_client.query("Journal").eq("user_id", @parse_user.id).get
    @user_data_query = @parse_client.query("UserData").eq("user_id", @parse_user.id).get
  end
=end

  #def find_timestamp(object_id)
  # @user_data_query do |user_data|
      # For mood, query userdata for object id and store date from userCreatedDate
      # then query key data type for object id and store timestamp time
      # For self_care and journal, query userdata for object id and store date
      # then query key data type for object id and store updatedAt time 
  # end
  #end

  # To beat 100 record limit, pull and store createdAt as @lastCreatedAt.
  # Then pull query with objects with createdAt after @lastCreatedAt

  def transform_and_load_parse_data(data_type, user_id)
    if data_type == "Mood"
      @parse_moods.each do |parse_mood|
        mood = Mood.create!(
          :mood_rating => parse_mood["moodRating"],
          :anxiety_rating => parse_mood["anxietyRating"] + 1,
          :irritability_rating => parse_mood["irritabilityRating"] + 1,
          :user_id => user_id
        )
        mood.timestamp = get_key_data_datetime_from_user_data("Mood", parse_mood["objectId"])
        mood.created_at = parse_mood["createdAt"]
        mood.updated_at = parse_mood["updatedAt"]
        mood.save!
      end

    elsif data_type == "Sleep"  
      @parse_sleeps.each do |parse_sleep|
        sleep = Sleep.create!(
          :start_time => parse_sleep["startTime"],
          :finish_time => parse_sleep["finishTime"],
          :time => (parse_sleep["finishTime"].to_i - parse_sleep["startTime"].to_i) / 3600,
          :quality => parse_sleep["quality"],
          :user_id => user_id
        )
        sleep.created_at = parse_sleep["createdAt"]
        sleep.updated_at = parse_sleep["updatedAt"]
        sleep.save!
      end

    elsif data_type == "SelfCare"
      @parse_self_cares.each do |parse_self_care|
        self_care = SelfCare.create!(
          :counseling => parse_self_care["counseling"],
          :medication => parse_self_care["medication"],
          :meditation => parse_self_care["meditation"],
          :exercise => parse_self_care["exercise"],
          :user_id => user_id
        )
        self_care.timestamp = get_key_data_datetime_from_user_data("SelfCare", parse_self_care["objectId"])
        self_care.created_at = parse_self_care["createdAt"]
        self_care.updated_at = parse_self_care["updatedAt"]
        self_care.save!
      end

    elsif data_type == "Journal"
      @parse_journals.each do |parse_journal|
        journal = Journal.create!(
          :journal_entry => parse_journal["journalEntry"],
          :user_id => user_id
        )
        journal.timestamp = get_key_data_datetime_from_user_data("Journal", parse_journal["objectId"])
        journal.created_at = parse_journal["createdAt"]
        journal.updated_at = parse_journal["updatedAt"]
        journal.save!
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

      extract_parse_data("Mood", @parse_user["objectId"], 0, @parse_mood_count)
      extract_parse_data("Sleep", @parse_user["objectId"], 0, @parse_sleep_count)
      #extract_parse_data("SelfCare", @parse_user["objectId"], 0, @parse_self_care_count)
      extract_parse_data("Journal", @parse_user["objectId"], 0, @parse_journal_count)
      
      transform_and_load_parse_data("Mood", user_id)
      transform_and_load_parse_data("Sleep", user_id)
      transform_and_load_parse_data("SelfCare", user_id)
      transform_and_load_parse_data("Journal", user_id)
    end
  end
end
