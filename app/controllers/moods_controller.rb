class MoodsController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  load_and_authorize_resource

  before_action :set_mood, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  Time.zone = 'EST'
  
  # GET /moods
  # GET /moods.json
  def index
    @moods = Mood.where(user_id: current_user.id)

    respond_to do |format|
      format.html
      format.json { render :json => @moods, status: 200 }
      format.xml { render :xml => @moods, status: 200 }
    end
  end

  # GET /moods/1
  # GET /moods/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :json =>  @mood, status: 200 }
      format.xml { render :xml => @mood, status: 200 }
    end
  end

  # GET /moods/new
  def new
    @mood= Mood.new
  end

  # GET /moods/1/edit
  def edit
  end

  # POST /moods
  # POST /moods.json
  def create
    @mood = Mood.new(mood_params)
    @mood.user_id = current_user.id
    @mood.update_attribute(:timestamp, DateTime.now.in_time_zone)
    
    respond_to do |format|
      if @mood.save
        format.html { redirect_to moods_url, notice: 'Mood Entry was successfully tracked.' }
        format.json { render :show, status: :created, location: moods_url }
      else
        format.html { render :new }
        format.json { render json: @mood.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moods/1
  # PATCH/PUT /moods/1.json
  def update
    respond_to do |format|
      if @mood.update(mood_params)
        format.html { redirect_to moods_url, notice: 'Mood Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: moods_url }

      elsif false #This will never happen as the user cannot edit for now.
        format.html { render :edit }
        format.json { render json: @mood.errors, status: :unprocessable_entity }

      else
        format.html { redirect_to @mood, notice: 'Mood Entry was not updated... Try again???' }
        format.json { render json: @mood.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moods/1
  # DELETE /moods/1.json
  def destroy
    @mood.destroy
    respond_to do |format|
      format.html { redirect_to moods_url, notice: 'Mood Entry was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mood
      @mood = Mood.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mood_params
      params.require(:mood).permit(:mood_rating, :anxiety_rating, :irritability_rating)
    end
end

