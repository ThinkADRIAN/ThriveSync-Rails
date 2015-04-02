class SleepsController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_sleep, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rails_user!

  if $PARSE_ENABLED
    before_action :sync_backends, only: [:index, :show, :edit, :update, :destroy]
  end

  respond_to :js

  Time.zone = 'EST'
  
  # GET /sleeps
  # GET /sleeps.json
  def index
    authorize! :manage, Sleep
    authorize! :read, Sleep
    @rails_user = RailsUser.find_by_id(params[:rails_user_id])
    if @rails_user == nil
      @sleeps = Sleep.where(user_id: current_rails_user.id)
    elsif @rails_user != nil
      @sleeps = Sleep.where(user_id: @rails_user.id)
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @sleeps, status: 200 }
      format.xml { render :xml => @sleeps, status: 200 }
    end
  end

  # GET /sleeps/1
  # GET /sleeps/1.json
  def show
    authorize! :manage, Sleep
    authorize! :read, Sleep

    respond_to do |format|
      format.js
      format.json { render :json =>  @sleep, status: 200 }
      format.xml { render :xml => @sleep, status: 200 }
    end
  end

  # GET /sleeps/new
  def new
    authorize! :manage, Sleep
    @sleep= Sleep.new
  end

  # GET /sleeps/1/edit
  def edit
    authorize! :manage, Sleep
  end

  # POST /sleeps
  # POST /sleeps.json
  def create
    authorize! :manage, Sleep
    @sleep = Sleep.new(sleep_params)
    @sleep.user_id = current_rails_user.id
    @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
    
    respond_to do |format|
      if @sleep.save
        if $PARSE_ENABLED

          # Create new Sleep object then write atributes to Parse
          parse_sleep = Parse::Object.new("Sleep")
          parse_sleep["startTime"] = Parse::Date.new(@sleep.start_time)
          parse_sleep["finishTime"] = Parse::Date.new(@sleep.finish_time)
          parse_sleep["quality"] =  @sleep.quality
          parse_sleep["time"] = @sleep.time
          parse_sleep["rails_user_id"] = @sleep.user_id.to_s
          parse_sleep["rails_id"] = @sleep.id.to_s
          parse_sleep["rails_sync_required"] = false
          parse_sleep.save

          # Retrieve User with corresponding Rails User ID
          user = Parse::Query.new("_User").eq("rails_user_id", @sleep.user_id.to_s).get.first

          # Set Parse User ID in Rails
          @sleep.parse_user_id = user["objectId"]
          @sleep.save

          # Set Parse User ID for Sleep Entry
          parse_sleep["user_id"] = user["objectId"]
          parse_sleep.save

          # Find the beginning of the same day as Sleep Entry creation date
          # and the beginning of the next day.  This is to be used to find
          # dates in between... Meaning on the same day
          date_check_begin = parse_sleep["createdAt"].to_date
          date_check_end =  date_check_begin.tomorrow
          date_check_begin = Parse::Date.new(date_check_begin)
          date_check_end = Parse::Date.new(date_check_end)

          # Set UserData entry for Sleep Entry
          user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
            q.eq("UserID", parse_sleep["user_id"])
            q.greater_than("createdAt", date_check_begin)
            q.less_than("createdAt", date_check_end)
          end.get.first

          if user_data == nil
            user_data = Parse::Object.new("UserData")
          end

          if user_data["Sleep"] == nil
            user_data["Sleep"] = Array.new
          end

          if user_data["Sleep"] == nil
            user_data["Sleep"] = parse_sleep.pointer
            user_data["UserID"] = parse_sleep["user_id"]  
            user_data.save

            flash.now[:success] = 'Sleep Entry was successfully tracked.'
            format.js
            format.json { render :show, status: :created, location: sleeps_url }
          else
            parse_sleep.parse_delete
            @sleep.destroy
            flash.now[:error] = 'Sleep Entry not created.  You already have one for this day.'
            format.js
            format.json { render :show, status: :created, location: sleeps_url }
          end
        elsif !$PARSE_ENABLED
          flash.now[:success] = 'Sleep Entry was successfully tracked.'
          format.js 
          format.json { render :show, status: :created, location: sleeps_url }
        end
      else
        format.js { render json: @sleep.errors, status: :unprocessable_entity }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sleeps/1
  # PATCH/PUT /sleeps/1.json
  def update
    authorize! :manage, Sleep

    respond_to do |format|
      if @sleep.update(sleep_params)
        @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
        @sleep.save

        flash.now[:success] = 'Sleep Entry was successfully updated.'
        format.js
        format.json { render :show, status: :ok, location: sleeps_url }

        if $PARSE_ENABLED
          parse_sleep = Parse::Query.new("Sleep").eq("rails_id", @sleep.id).get.first

          parse_sleep["startTime"] = Parse::Date.new(@sleep.start_time)
          parse_sleep["finishTime"] = Parse::Date.new(@sleep.finish_time)
          parse_sleep["quality"] =  @sleep.quality
          parse_sleep["time"] = @sleep.time
          parse_sleep["rails_user_id"] = @sleep.user_id
          parse_sleep["rails_id"] = @sleep.id
          parse_sleep["rails_sync_required"] = false
          parse_sleep.save
        end
      elsif false #This will never happen as the user cannot edit for now.
        format.js
        format.json { render json: @sleep.errors, status: :unprocessable_entity }

      else
        flash.now[:error] = 'Sleep Entry was not updated... Try again???'
        format.js { render json: @sleep.errors, status: :unprocessable_entity }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    authorize! :manage, Sleep
    @sleep = Sleep.find(params[:sleep_id])
  end

  # DELETE /sleeps/1
  # DELETE /sleeps/1.json
  def destroy
    authorize! :manage, Sleep
    @sleep.destroy

    respond_to do |format|
    
      if $PARSE_ENABLED
        parse_sleep = Parse::Query.new("Sleep").eq("rails_id", @sleep.id.to_s).get.first
        user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
          q.eq("UserID", parse_sleep["user_id"])
          q.eq("Sleep", parse_sleep.pointer)
        end.get.first

        user_data["Sleep"] = nil
        user_data.save
        parse_sleep.parse_delete

        if user_data["Mood"] == nil && user_data["Sleep"] == nil && user_data["SelfCare"] == nil && user_data["Journal"] == nil
          user_data.parse_delete
        end
        
      end
      flash.now[:success] = 'Sleep Entry was successfully removed.'
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sleep
      @sleep = Sleep.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sleep_params
      params.require(:sleep).permit(:start_time, :finish_time, :quality)
    end

  def sync_new_rails_record(parse_sleep)
    @sleep = Sleep.new

    if @rails_user == nil
      rails_user = current_user
    elsif @rails_user != nil
      rails_user = @rails_user
    end

    @sleep.start_time = parse_sleep["startTime"]
    @sleep.finish_time = parse_sleep["finishTime"]
    @sleep.quality = parse_sleep["quality"]
    @sleep.time = parse_sleep["time"]
    @sleep.user_id = rails_user.id
    @sleep.save
    parse_sleep["rails_user_id"] = @sleep.user_id.to_s
    parse_sleep["rails_id"] = @sleep.id.to_s
    parse_sleep.save

    # Retrieve User with corresponding Rails User ID
    user = Parse::Query.new("_User").eq("rails_user_id", @sleep.user_id.to_s).get.first

    # Set Parse User ID in Rails
    @sleep.parse_user_id = user["objectId"]
    @sleep.save

    # Set Parse User ID for Sleep Entry
    parse_sleep["user_id"] = user["objectId"]
    parse_sleep.save

    # Find the beginning of the same day as Sleep Entry creation date
    # and the beginning of the next day.  This is to be used to find
    # dates in between... Meaning on the same day
    date_check_begin = parse_sleep["createdAt"].to_date
    date_check_end =  date_check_begin.tomorrow
    date_check_begin = Parse::Date.new(date_check_begin)
    date_check_end = Parse::Date.new(date_check_end)

    # Set UserData entry for Sleep Entry
    user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
      q.eq("UserID", parse_sleep["user_id"])
      q.greater_than("createdAt", date_check_begin)
      q.less_than("createdAt", date_check_end)
    end.get.first

    if user_data == nil
      user_data = Parse::Object.new("UserData")
    end

    if user_data["Sleep"] == nil
      user_data["Sleep"] = Array.new
    end

    if user_data["Sleep"] == nil
      user_data["Sleep"] << parse_sleep.pointer
      user_data["UserID"] = parse_sleep["user_id"]
      user_data.save
    end
  end

  def sync_rails_record(parse_sleep_rails_id)
    @sleep = Sleep.where(id: parse_sleep_rails_id.to_i).first
    parse_sleep = Parse::Query.new("Sleep").eq("rails_id", parse_sleep_rails_id.to_s).get.first

    @sleep.start_time = parse_sleep["startTime"]
    @sleep.finish_time = parse_sleep["finishTime"]
    @sleep.quality = parse_sleep["quality"]
    @sleep.time = parse_sleep["time"]
    @sleep.save
  end

  def sync_deleted_sleep(rails_sleep)
    @sleep = Sleep.where(id: rails_sleep.id.to_i).first
    @sleep.destroy
  end

  def sync_backends
    # Get all Sleeps for user
    if @rails_user == nil
      @sleeps = Sleep.where(user_id: current_rails_user.id)
      @parse_sleeps = Parse::Query.new("Sleep").eq("user_id", current_rails_user.parse_user_id.to_s).get
    elsif @rails_user != nil
      @sleeps = Sleep.where(user_id: @rails_user.id)
      @parse_sleeps = Parse::Query.new("Sleep").eq("user_id", @rails_user.parse_user_id.to_s).get
    end

    parse_unsynced_sleeps = []
    parse_deleted_sleeps = []

    # Find Parse Records with rails_sync_required = true
    @parse_sleeps.each do |p|
      if p["rails_sync_required"] == true
        parse_unsynced_sleeps.unshift(p)
      end
    end

    # Find Rails Records that no longer exist in Parse
    @sleeps.each do |r|
      if !@parse_sleeps.any? {|h| h["rails_id"] == r.id.to_s}
        parse_deleted_sleeps << r
      end
    end

    parse_unsynced_sleeps.each do |p|
      # If rails_id is blank then add the record to rails
      if p["rails_id"].blank?
        sync_new_rails_record(p)
        # Elsif rails_id is set then update record in rails
      elsif !p["rails_id"].blank?
        sync_rails_record(p["rails_id"])
      end
      p["rails_sync_required"] = false
      p.save
    end

    parse_deleted_sleeps.each do |r|
      sync_deleted_sleep(r)
    end
  end
end