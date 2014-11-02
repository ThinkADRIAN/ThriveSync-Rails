class SelfCaresController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  load_and_authorize_resource

  before_action :set_self_care, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rails_user!

  Time.zone = 'EST'
  
  # GET /self_cares
  # GET /self_cares.json
  def index
    @rails_user = RailsUser.find_by_id(params[:rails_user_id])
    if @rails_user == nil
      @self_cares = SelfCare.where(user_id: current_rails_user.id)
    elsif @rails_user != nil
      @self_cares = SelfCare.where(user_id: @rails_user.id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @self_cares, status: 200 }
      format.xml { render :xml => @self_cares, status: 200 }
    end
  end

  # GET /self_cares/1
  # GET /self_cares/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :json =>  @self_care, status: 200 }
      format.xml { render :xml => @self_care, status: 200 }
    end
  end

  # GET /self_cares/new
  def new
    @self_care= SelfCare.new
  end

  # GET /self_cares/1/edit
  def edit
  end

  # POST /self_cares
  # POST /self_cares.json
  def create
    @self_care = SelfCare.new(self_care_params)
    @self_care.user_id = current_rails_user.id
    
    respond_to do |format|
      if @self_care.save

        # Create new Self Care object then write atributes to Parse
        parse_self_care = Parse::Object.new("SelfCare")
        parse_self_care["counseling"] = @self_care.counseling
        parse_self_care["medication"] = @self_care.medication
        parse_self_care["meditation"] = @self_care.meditation
        parse_self_care["exercise"] = @self_care.exercise
        parse_self_care["rails_user_id"] = @self_care.user_id.to_s
        parse_self_care["rails_id"] = @self_care.id.to_s
        parse_self_care.save

        # Retrieve User with corresponding Rails User ID
        user = Parse::Query.new("_User").eq("rails_user_id", @self_care.user_id.to_s).get.first

        # Set Parse User ID in Rails
        @self_care.parse_user_id = user["objectId"]
        @self_care.save

        # Set Parse User ID for Self Care Entry
        parse_self_care["user_id"] = user["objectId"]
        parse_self_care.save

        # Find the beginning of the same day as Self Care Entry creation date
        # and the beginning of the next day.  This is to be used to find
        # dates in between... Meaning on the same day
        date_check_begin = parse_self_care["createdAt"].to_date
        date_check_end =  date_check_begin.tomorrow
        date_check_begin = Parse::Date.new(date_check_begin)
        date_check_end = Parse::Date.new(date_check_end)

        # Set UserData entry for Sleep Entry
        user_data_query = Parse::Query.new("UserData").tap do |q|
          q.eq("UserID", parse_self_care["user_id"])
          q.greater_than("createdAt", date_check_begin)
          q.less_than("createdAt", date_check_end)
        end.get.first

        user_data = user_data_query

        if user_data == nil
          user_data = Parse::Object.new("UserData")
        end

        if user_data["SelfCare"] == nil
          user_data["SelfCare"] = parse_self_care.pointer
          user_data["UserID"] = parse_self_care["user_id"]  
          user_data.save

          # Add UserData entry to User Entry
          if user["UserData"] == nil
            user["UserData"] = Array.new
          end

          if !user["UserData"].include?(user_data.pointer)
            user["UserData"] << user_data.pointer
            user.save
          end

          format.html { redirect_to self_cares_url, notice: 'Self Entry was successfully tracked.' }
          format.json { render :show, status: :created, location: sleeps_url }
        else
          parse_self_care.parse_delete
          @self_care.destroy
          format.html { redirect_to self_cares_url, notice: 'Self Care Entry not created.  You already have one for this day.' }
        end

      else
        format.html { render :new }
        format.json { render json: @self_care.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /self_cares/1
  # PATCH/PUT /self_cares/1.json
  def update
    respond_to do |format|
      if @self_care.update(self_care_params)
        format.html { redirect_to self_cares_url, notice: 'Self Care Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: self_cares_url }

        parse_self_care = Parse::Query.new("SelfCare").eq("rails_id", @self_care.id.to_s).get.first

        parse_self_care["counseling"] = @self_care.counseling
        parse_self_care["medication"] = @self_care.medication
        parse_self_care["meditation"] = @self_care.meditation
        parse_self_care["exercise"] = @self_care.exercise
        parse_self_care["rails_id"] = @self_care.id.to_s
        parse_self_care.save

      elsif false #This will never happen as the user cannot edit for now.
        format.html { render :edit }
        format.json { render json: @self_care.errors, status: :unprocessable_entity }

      else
        format.html { redirect_to @self_care, notice: 'Self Care Entry was not updated... Try again???' }
        format.json { render json: @self_care.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /self_cares/1
  # DELETE /self_cares/1.json
  def destroy
    @self_care.destroy
    respond_to do |format|
      
      parse_self_care = Parse::Query.new("SelfCare").eq("rails_id", @self_care.id.to_s).get.first
      user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
        q.eq("UserID", parse_self_care["user_id"])
        q.eq("SelfCare", parse_self_care.pointer)
      end.get.first

      user_data["SelfCare"] = nil
      user_data.save
      parse_self_care.parse_delete

      if user_data["Mood"] == nil && user_data["Sleep"] == nil && user_data["SelfCare"] == nil && user_data["Journal"] == nil
        user = Parse::Query.new("_User").eq("rails_user_id", @self_care.user_id.to_s).get.first
        user["UserData"].delete(user_data.pointer)
        if user["UserData"] == []
          user["UserData"] = nil
        end
        user_data.parse_delete
        user.save
      end

      format.html { redirect_to self_cares_url, notice: 'Self Care Entry was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_self_care
      @self_care = SelfCare.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def self_care_params
      params.require(:self_care).permit( :counseling, :medication, :meditation, :exercise)
    end
end


