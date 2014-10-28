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

        # Create new Journal object then write atributes to Parse
        parse_journal = Parse::Object.new("Journal")
        parse_journal["journalEntry"] = @journal.journal_entry
        parse_journal["rails_user_id"] = @journal.user_id.to_s
        parse_journal["rails_id"] = @journal.id.to_s
        parse_journal.save

        # Retrieve User with corresponding Rails User ID
        user = Parse::Query.new("_User").eq("rails_user_id", @journal.user_id.to_s).get.first

        # Set Parse User ID in Rails
        @journal.parse_user_id = user["objectId"]
        @journal.save

        # Set Parse User ID for Journal Entry
        parse_journal["user_id"] = user["objectId"]
        parse_journal.save

        # Find the beginning of the same day as Journal Entry creation date
        # and the beginning of the next day.  This is to be used to find
        # dates in between... Meaning on the same day
        date_check_begin = parse_journal["createdAt"].to_date
        date_check_end =  date_check_begin.tomorrow
        date_check_begin = Parse::Date.new(date_check_begin)
        date_check_end = Parse::Date.new(date_check_end)

        # Set UserData entry for Sleep Entry
        user_data_query = Parse::Query.new("UserData").tap do |q|
          q.eq("UserID", parse_journal["user_id"])
          q.greater_than("createdAt", date_check_begin)
          q.less_than("createdAt", date_check_end)
        end.get.first

        user_data = user_data_query

        if user_data == nil
          user_data = Parse::Object.new("UserData")
        end

        if user_data["Journal"] == nil
          user_data["Journal"] = parse_journal.pointer
          user_data["UserID"] = parse_journal["user_id"]  
          user_data.save

          # Add UserData entry to User Entry
          if user["UserData"] == nil
            user["UserData"] = Array.new
          end
          if !user["UserData"].include?(user_data.pointer)
            user["UserData"] << user_data.pointer
            user.save
          end

          format.html { redirect_to journals_url, notice: 'Journal was successfully tracked.' }
          format.json { render :show, status: :created, location: sleeps_url }
        else
          parse_journal.parse_delete
          @journal.destroy
          format.html { redirect_to journals_url, notice: 'Journal Entry not created.  You already have one for this day.' }
        end

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

        parse_journal = Parse::Query.new("Journal").eq("rails_id", @journal.id.to_s).get.first

        parse_journal["journalEntry"] = @journal.journal_entry
        parse_journal["rails_user_id"] = @journal.user_id.to_s
        parse_journal["rails_id"] = @journal.id.to_s
        parse_journal.save

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

      parse_journal = Parse::Query.new("Journal").eq("rails_id", @journal.id.to_s).get.first
      parse_journal.parse_delete
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

