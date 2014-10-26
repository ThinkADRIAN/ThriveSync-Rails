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
    @self_cares = SelfCare.where(user_id: current_rails_user.id)

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
        format.html { redirect_to self_cares_url, notice: 'Self Care Entry was successfully tracked.' }
        format.json { render :show, status: :created, location: self_cares_url }

        parse_self_care = Parse::Object.new("SelfCare")
        parse_self_care["counseling"] = @self_care.counseling
        parse_self_care["medication"] = @self_care.medication
        parse_self_care["meditation"] = @self_care.meditation
        parse_self_care["exercise"] = @self_care.exercise
        parse_self_care["rails_user_id"] = @self_care.user_id.to_s
        parse_self_care["rails_id"] = @self_care.id.to_s
        parse_self_care.save

        user = Parse::Query.new("_User").eq("rails_user_id", @self_care.user_id.to_s).get.first

        @self_care.parse_user_id = user["objectId"]
        @self_care.save

        parse_self_care["user_id"] = user["objectId"]
        parse_self_care.save
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
      format.html { redirect_to self_cares_url, notice: 'Self Care Entry was successfully removed.' }
      format.json { head :no_content }

      parse_self_care = Parse::Query.new("SelfCare").eq("rails_id", @self_care.id.to_s).get.first
      parse_self_care.parse_delete
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


