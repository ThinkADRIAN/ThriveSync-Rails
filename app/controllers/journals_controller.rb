class JournalsController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  load_and_authorize_resource

  before_action :set_journal, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rails_user!

  Time.zone = 'EST'
  
  # GET /journals
  # GET /journals.json
  def index
    @journals = Journal.where(user_id: current_rails_user.id)

    respond_to do |format|
      format.html
      format.json { render :json => @journals, status: 200 }
      format.xml { render :xml => @journals, status: 200 }
    end
  end

  # GET /journals/1
  # GET /journals/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :json =>  @journal, status: 200 }
      format.xml { render :xml => @journal, status: 200 }
    end
  end

  # GET /journals/new
  def new
    @journal= Journal.new
  end

  # GET /journals/1/edit
  def edit
  end

  # POST /journals
  # POST /journals.json
  def create
    @journal = Journal.new(journal_params)
    @journal.user_id = current_rails_user.id
    
    respond_to do |format|
      if @journal.save
        format.html { redirect_to journals_url, notice: 'Journal Entry was successfully tracked.' }
        format.json { render :show, status: :created, location: journals_url }

        parse_journal = Parse::Object.new("Journal")
        parse_journal["journalEntry"] = @journal.journal_entry
        parse_journal["rails_user_id"] = @journal.user_id.to_s
        parse_journal["rails_id"] = @journal.id.to_s
        parse_journal.save

        user = Parse::Query.new("_User").eq("rails_user_id", @journal.user_id.to_s).get.first

        @journal.parse_user_id = user["objectId"]
        @journal.save

        parse_journal["user_id"] = user["objectId"]
        parse_journal.save
      else
        format.html { render :new }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /journals/1
  # PATCH/PUT /journals/1.json
  def update
    respond_to do |format|
      if @journal.update(journal_params)
        format.html { redirect_to journals_url, notice: 'Journal Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: journals_url }

      elsif false #This will never happen as the user cannot edit for now.
        format.html { render :edit }
        format.json { render json: @journal.errors, status: :unprocessable_entity }

      else
        format.html { redirect_to @journal, notice: 'Journal Entry was not updated... Try again???' }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.json
  def destroy
    @journal.destroy
    respond_to do |format|
      format.html { redirect_to journals_url, notice: 'Journal Entry was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def journal_params
      params.require(:journal).permit(:journal_entry)
    end
end

