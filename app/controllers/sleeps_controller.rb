class SleepsController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  load_and_authorize_resource

  before_action :set_sleep, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rails_user!

  Time.zone = 'EST'
  
  # GET /sleeps
  # GET /sleeps.json
  def index
    @rails_user = RailsUser.find_by_id(params[:rails_user_id])
    if @rails_user == nil
      @sleeps = Sleep.where(user_id: current_rails_user.id)
    elsif @rails_user != nil
      @sleeps = Sleep.where(user_id: @rails_user.id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @sleeps, status: 200 }
      format.xml { render :xml => @sleeps, status: 200 }
    end
  end

  # GET /sleeps/1
  # GET /sleeps/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :json =>  @sleep, status: 200 }
      format.xml { render :xml => @sleep, status: 200 }
    end
  end

  # GET /sleeps/new
  def new
    @sleep= Sleep.new
  end

  # GET /sleeps/1/edit
  def edit
  end

  # POST /sleeps
  # POST /sleeps.json
  def create
    @sleep = Sleep.new(sleep_params)
    @sleep.user_id = current_rails_user.id
    @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
    
    respond_to do |format|
      if @sleep.save

        # Create new Sleep object then write atributes to Parse
        parse_sleep = Parse::Object.new("Sleep")
        parse_sleep["startTime"] = Parse::Date.new(@sleep.start_time)
        parse_sleep["finishTime"] = Parse::Date.new(@sleep.finish_time)
        parse_sleep["quality"] =  @sleep.quality
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
        user_data_query = Parse::Query.new("UserData").tap do |q|
          q.eq("UserID", parse_sleep["user_id"])
          q.greater_than("createdAt", date_check_begin)
          q.less_than("createdAt", date_check_end)
        end.get.first

        user_data = user_data_query

        if user_data == nil
          user_data = Parse::Object.new("UserData")
        end

        if user_data["Sleep"] == nil
          user_data["Sleep"] = parse_sleep.pointer
          user_data["UserID"] = parse_sleep["user_id"]  
          user_data.save

          # Add UserData entry to User Entry
          if user["UserData"] == nil
            user["UserData"] = Array.new
          end
          
          if !user["UserData"].include?(user_data.pointer)
            user["UserData"] << user_data.pointer
            user.save
          end

          format.html { redirect_to sleeps_url, notice: 'Sleep Entry was successfully tracked.' }
          format.json { render :show, status: :created, location: sleeps_url }
        else
          parse_sleep.parse_delete
          @sleep.destroy
          format.html { redirect_to sleeps_url, notice: 'Sleep Entry not created.  You already have one for this day.' }
        end

      else
        format.html { render :new }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sleeps/1
  # PATCH/PUT /sleeps/1.json
  def update
    @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
    respond_to do |format|
      if @sleep.update(sleep_params)
        format.html { redirect_to sleeps_url, notice: 'Sleep Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: sleeps_url }

        parse_sleep = Parse::Query.new("Sleep").eq("rails_id", @sleep.id).get.first

        parse_sleep["startTime"] = Parse::Date.new(@sleep.start_time)
        parse_sleep["finishTime"] = Parse::Date.new(@sleep.finish_time)
        parse_sleep["quality"] =  @sleep.quality
        parse_sleep["rails_user_id"] = @sleep.user_id
        parse_sleep["rails_id"] = @sleep.id
        parse_sleep.save

      elsif false #This will never happen as the user cannot edit for now.
        format.html { render :edit }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }

      else
        format.html { redirect_to @sleep, notice: 'Sleep Entry was not updated... Try again???' }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sleeps/1
  # DELETE /sleeps/1.json
  def destroy
    @sleep.destroy
    respond_to do |format|

      parse_sleep = Parse::Query.new("Sleep").eq("rails_id", @sleep.id.to_s).get.first
      user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
        q.eq("UserID", parse_sleep["user_id"])
        q.eq("Sleep", parse_sleep.pointer)
      end.get.first

      user_data["Sleep"] = nil
      user_data.save
      parse_sleep.parse_delete

      if user_data["Mood"] == nil && user_data["Sleep"] == nil && user_data["SelfCare"] == nil && user_data["Journal"] == nil
        user = Parse::Query.new("_User").eq("rails_user_id", @sleep.user_id.to_s).get.first
        user["UserData"].delete(user_data.pointer)
        if user["UserData"] == []
          user["UserData"] = nil
        end
        user_data.parse_delete
        user.save
      end

      format.html { redirect_to sleeps_url, notice: 'Sleep Entry was successfully removed.' }
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
end


