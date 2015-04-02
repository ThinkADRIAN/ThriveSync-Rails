class SelfCaresController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_self_care, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rails_user!

  if $PARSE_ENABLED
    before_action :sync_backends, only: [:index, :show, :edit, :update, :destroy]
  end

  respond_to :html, :js, :json, :xml

  Time.zone = 'EST'
  
  # GET /self_cares
  # GET /self_cares.json
  def index
    authorize! :manage, SelfCare
    authorize! :read, SelfCare
    @rails_user = RailsUser.find_by_id(params[:rails_user_id])
    
    if @rails_user == nil
      @self_cares = SelfCare.where(user_id: current_rails_user.id)
    elsif @rails_user != nil
      @self_cares = SelfCare.where(user_id: @rails_user.id)
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @self_cares, status: 200 }
      format.xml { render :xml => @self_cares, status: 200 }
    end
  end

  # GET /self_cares/1
  # GET /self_cares/1.json
  def show
    authorize! :manage, SelfCare
    authorize! :read, SelfCare
    
    respond_to do |format|
      format.js
      format.json { render :json =>  @self_care, status: 200 }
      format.xml { render :xml => @self_care, status: 200 }
    end
  end

  # GET /self_cares/new
  def new
    authorize! :manage, SelfCare
    @self_care= SelfCare.new
  end

  # GET /self_cares/1/edit
  def edit
    authorize! :manage, SelfCare
  end

  # POST /self_cares
  # POST /self_cares.json
  def create
    authorize! :manage, SelfCare
    @self_care = SelfCare.new(self_care_params)
    @self_care.user_id = current_rails_user.id
    
    respond_to do |format|
      if @self_care.save
        if $PARSE_ENABLED

          # Create new Self Care object then write atributes to Parse
          parse_self_care = Parse::Object.new("SelfCare")
          parse_self_care["counseling"] = @self_care.counseling
          parse_self_care["medication"] = @self_care.medication
          parse_self_care["meditation"] = @self_care.meditation
          parse_self_care["exercise"] = @self_care.exercise
          parse_self_care["rails_user_id"] = @self_care.user_id.to_s
          parse_self_care["rails_id"] = @self_care.id.to_s
          parse_self_care["rails_sync_required"] = false
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
          user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
            q.eq("UserID", parse_self_care["user_id"])
            q.greater_than("createdAt", date_check_begin)
            q.less_than("createdAt", date_check_end)
          end.get.first

          if user_data == nil
            user_data = Parse::Object.new("UserData")
          end

          if user_data["SelfCare"] == nil
            user_data["SelfCare"] = Array.new
          end

          if user_data["SelfCare"].count < 1
            user_data["SelfCare"] = parse_self_care.pointer
            user_data["UserID"] = parse_self_care["user_id"]  
            user_data.save

            flash.now[:success] = "Self Entry was successfully tracked."
            format.js
            format.json { render :show, status: :created, location: sleeps_url }
          else
            parse_self_care.parse_delete
            @self_care.destroy
            flash.now[:error] = "Self Care Entry not created.  You already have one for this day."
            format.js
            format.json { render :show, status: :created, location: self_cares_url }
          end
        elsif !$PARSE_ENABLED
          flash.now[:success] = "Self Entry was successfully tracked."
          format.js
          format.json { render :show, status: :created, location: self_cares_url }
        end
      else
        format.js   { render json: @self_care.errors, status: :unprocessable_entity }
        format.json { render json: @self_care.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /self_cares/1
  # PATCH/PUT /self_cares/1.json
  def update
    authorize! :manage, SelfCare
    
    respond_to do |format|
      if @self_care.update(self_care_params)
        flash.now[:success] = "Self Care Entry was successfully updated."
        format.js
        format.json { render :show, status: :ok, location: self_cares_url }

        if $PARSE_ENABLED
          parse_self_care = Parse::Query.new("SelfCare").eq("rails_id", @self_care.id.to_s).get.first

          parse_self_care["counseling"] = @self_care.counseling
          parse_self_care["medication"] = @self_care.medication
          parse_self_care["meditation"] = @self_care.meditation
          parse_self_care["exercise"] = @self_care.exercise
          parse_self_care["rails_id"] = @self_care.id.to_s
          parse_self_care.save
        end

      elsif false #This will never happen as the user cannot edit for now.
        format.js
        format.json { render json: @self_care.errors, status: :unprocessable_entity }

      else
        flash.now[:error] = 'Self Care Entry was not updated... Try again???'
        format.js   { render json: @self_care.errors, status: :unprocessable_entity }
        format.json { render json: @self_care.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    authorize! :manage, SelfCare
    @self_care = SelfCare.find(params[:self_care_id])
  end

  # DELETE /self_cares/1
  # DELETE /self_cares/1.json
  def destroy
    authorize! :manage, SelfCare
    @self_care.destroy
    
    respond_to do |format|
      
      if $PARSE_ENABLED
        parse_self_care = Parse::Query.new("SelfCare").eq("rails_id", @self_care.id.to_s).get.first
        user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
          q.eq("UserID", parse_self_care["user_id"])
          q.eq("SelfCare", parse_self_care.pointer)
        end.get.first

        user_data["SelfCare"] = nil
        user_data.save
        parse_self_care.parse_delete

        if user_data["Mood"] == nil && user_data["Sleep"] == nil && user_data["SelfCare"] == nil && user_data["Journal"] == nil
          user_data.parse_delete
        end
      end
      
      flash.now[:success] = "Self Care Entry was successfully removed."
      format.js 
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

    def sync_new_rails_record(parse_self_care)
      @self_care = SelfCare.new

      if @rails_user == nil
        rails_user = current_user
      elsif @rails_user != nil
        rails_user = @rails_user
      end

      @self_care.counseling = parse_self_care["counseling"]
      @self_care.medication = parse_self_care["medication"]
      @self_care.meditation = parse_self_care["meditation"]
      @self_care.exercise = parse_self_care["exercise"]
      @self_care.user_id = rails_user.id
      @self_care.save
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

      # Find the beginning of the same day as Mood Entry creation date
      # and the beginning of the next day.  This is to be used to find
      # dates in between... Meaning on the same day
      date_check_begin = parse_self_care["createdAt"].to_date
      date_check_end =  date_check_begin.tomorrow
      date_check_begin = Parse::Date.new(date_check_begin)
      date_check_end = Parse::Date.new(date_check_end)

      # Set UserData entry for Self Care Entry
      user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
        q.eq("UserID", parse_self_care["user_id"])
        q.greater_than("createdAt", date_check_begin)
        q.less_than("createdAt", date_check_end)
      end.get.first

      if user_data == nil
        user_data = Parse::Object.new("UserData")
      end

      if user_data["SelfCare"] == nil
        user_data["SelfCare"] = Array.new
      end

      if user_data["SelfCare"] == nil
        user_data["SelfCare"] << parse_self_care.pointer
        user_data["UserID"] = parse_self_care["user_id"]
        user_data.save
      end
    end

    def sync_rails_record(parse_self_care_rails_id)
      @self_care = SelfCare.where(id: parse_self_care_rails_id.to_i).first
      parse_self_care = Parse::Query.new("SelfCare").eq("rails_id", parse_self_care_rails_id.to_s).get.first

      @self_care.counseling = parse_self_care["counseling"]
      @self_care.medication = parse_self_care["medication"]
      @self_care.meditation = parse_self_care["meditation"]
      @self_care.exercise = parse_self_care["exercise"]
      @self_care.save
    end

    def sync_deleted_self_care(rails_self_care)
      @self_care = SelfCare.where(id: rails_self_care.id.to_i).first
      @self_care.destroy
    end

    def sync_backends
      # Get all Self Cares for user
      if @rails_user == nil
        @self_cares = SelfCare.where(user_id: current_rails_user.id)
        @parse_self_cares = Parse::Query.new("SelfCare").eq("user_id", current_rails_user.parse_user_id.to_s).get
      elsif @rails_user != nil
        @self_cares = SelfCare.where(user_id: @rails_user.id)
        @parse_self_cares = Parse::Query.new("SelfCare").eq("user_id", @rails_user.parse_user_id.to_s).get
      end

      parse_unsynced_self_cares = []
      parse_deleted_self_cares = []

      # Find Parse Records with rails_sync_required = true
      @parse_self_cares.each do |p|
        if p["rails_sync_required"] == true
          parse_unsynced_self_cares.unshift(p)
        end
      end

      # Find Rails Records that no longer exist in Parse
      @self_cares.each do |r|
        if !@parse_self_cares.any? {|h| h["rails_id"] == r.id.to_s}
          parse_deleted_self_cares << r
        end
      end

      parse_unsynced_self_cares.each do |p|
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

      parse_deleted_self_cares.each do |r|
        sync_deleted_self_care(r)
      end
    end
end