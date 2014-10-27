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
    @sleeps = Sleep.where(user_id: current_rails_user.id)

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
        format.html { redirect_to sleeps_url, notice: 'Sleep Entry was successfully tracked.' }
        format.json { render :show, status: :created, location: sleeps_url }

        # Create new Sleep object then write atributes to Parse
        parse_sleep = Parse::Object.new("Sleep")
        parse_sleep["startTime"] = Parse::Date.new(@sleep.start_time)
        parse_sleep["finishTime"] = Parse::Date.new(@sleep.finish_time)
        parse_sleep["quality"] =  @sleep.quality
        parse_sleep["rails_user_id"] = @sleep.user_id
        parse_sleep["rails_id"] = @sleep.id
        parse_sleep.save

        # Retrieve User with corresponding Rails User ID
        user = Parse::Query.new("_User").eq("rails_user_id", @sleep.user_id.to_s).get.first

        # Set Parse User ID in Rails
        @sleep.parse_user_id = user["objectId"]
        @sleep.save

        # Set Parse User ID for Mood Entry
        parse_sleep["user_id"] = user["objectId"]
        parse_sleep.save

        # Set UserData entry for Sleep Entry
        user_data_query = Parse::Query.new("UserData").tap do |q|
          q.eq("UserID", parse_sleep["user_id"])
          q.eq("createdAt".eql?(Parse::Date.new(parse_sleep["createdAt"]).to_date), true )
          # q.eq(Date.parse("createdAt").to_s, Date.parse(parse_mood["createdAt"]).to_s)
          # q.eq(("createdAt" - Parse::Date.new(@mood.timestamp)).abs, 0)
        end.get.first

        user_data = user_data_query
        if user_data == nil
          user_data = Parse::Object.new("UserData")
        end
        if user_data["Sleep"] == nil
          user_data["Sleep"] = Array.new
        end
        user_data["Sleep"] = parse_sleep.pointer
        user_data["UserID"] = parse_sleep["user_id"]  
        user_data.save

        # Add UserData entry to User Entry
        #if user["UserData"] == nil
        #  user["UserData"] = Array.new
        #end
        #user["UserData"] << user_data.pointer
        #user.save

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
      format.html { redirect_to sleeps_url, notice: 'Sleep Entry was successfully removed.' }
      format.json { head :no_content }

      parse_sleep = Parse::Query.new("Sleep").eq("rails_id", @sleep.id).get.first
      parse_sleep.parse_delete
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


