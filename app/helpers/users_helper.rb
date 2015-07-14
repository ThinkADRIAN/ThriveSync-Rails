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
        q.eq("UserID", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    elsif parse_data_type == "Sleep"
      @parse_sleep_count = Parse::Query.new("Sleep").tap do |q|
        q.eq("UserID", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    elsif parse_data_type == "SelfCare"
      @parse_self_care_count = Parse::Query.new("SelfCare").tap do |q|
        q.eq("UserID", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    elsif parse_data_type == "Journal"
      @parse_journal_count = Parse::Query.new("Journal").tap do |q|
        q.eq("UserID", @parse_user.id)
        q.limit = 0
        q.count
      end.get
    end 
  end

  def extract_parse_data(parse_data_type, last_object_limit)
    if parse_data_type == "UserData"
      @user_data <<  Parse::Query.new("UserData")
        q.limit = 100
        q.skip = last_object_limit
      end.get
    elsif parse_data_type == "Mood"
      @parse_mood <<  Parse::Query.new("Mood")
        q.limit = 100
        q.skip = last_object_limit
      end.get
    elsif parse_data_type == "Sleep"
      @parse_sleep <<  Parse::Query.new("Sleep")
        q.limit = 100
        q.skip = last_object_limit
      end.get
    elsif parse_data_type == "SelfCare"
      @parse_self_care <<  Parse::Query.new("SelfCare")
        q.limit = 100
        q.skip = last_object_limit
      end.get
    elsif parse_data_type == "Journal"
      @parse_journal <<  Parse::Query.new("Journal")
        q.limit = 100
        q.skip = last_object_limit
      end.get
    end
      
    if last_object_limit < @user_data_count
      extract_parse_data(parse_data_type, last_object_limit + 100)
    end
  end

  def extract_parse_data
    @parse_client = $parse_client
    @mood_query = @parse_client.query("Mood").eq("user_id", @parse_user.id).get
    @sleep_query = @parse_client.query("Sleep").eq("user_id", @parse_user.id).get
    @self_care_query = @parse_client.query("SelfCare").eq("user_id", @parse_user.id).get
    @journal_query = @parse_client.query("Journal").eq("user_id", @parse_user.id).get
    @user_data_query = @parse_client.query("UserData").eq("user_id", @parse_user.id).get
  end

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

  def transform_and_load_parse_data(user_id)
    @mood_query.each do |parse_mood|
      mood = Mood.create!(
        :mood_rating => parse_mood["moodRating"],
        :anxiety_rating => parse_mood["anxietyRating"] + 1,
        :irritability_rating => parse_mood["irritabilityRating"] + 1,
        :user_id => user_id
      )
      mood.timestamp = parse_mood["timeStamp"]
      mood.created_at = parse_mood["createdAt"]
      mood.updated_at = parse_mood["updatedAt"]
      mood.save!
    end

    @sleep_query.each do |parse_sleep|
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

    @self_care_query.each do |parse_self_care|
      self_care = SelfCare.create!(
        :counseling => parse_self_care["counseling"],
        :medication => parse_self_care["medication"],
        :meditation => parse_self_care["meditation"],
        :exercise => parse_self_care["exercise"],
        :user_id => user_id
      )
      self_care.timestamp = parse_self_care["createdAt"]
      self_care.created_at = parse_self_care["createdAt"]
      self_care.updated_at = parse_self_care["updatedAt"]
      self_care.save!
    end

    @journal_query.each do |parse_journal|
      journal = Journal.create!(
        :journal_entry => parse_journal["journalEntry"],
        :user_id => user_id
      )
      journal.timestamp = parse_journal["createdAt"]
      journal.created_at = parse_journal["createdAt"]
      journal.updated_at = parse_journal["updatedAt"]
      journal.save!
    end
  end

  def etl_for_parse(user_id)
    login_to_parse
    if @parse_user != nil
      extract_parse_data
      transform_and_load_parse_data(user_id)
    end
  end
end
