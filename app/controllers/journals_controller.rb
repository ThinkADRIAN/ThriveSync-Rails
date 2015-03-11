class JournalsController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_journal, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rails_user!

  if $PARSE_ENABLED
    before_action :sync_backends, only: [:index, :show, :edit, :update, :destroy]
  end

  Time.zone = 'EST'
  
  # GET /journals
  # GET /journals.json
  def index
    authorize! :manage, Journal
    authorize! :read, Journal
    @rails_user = RailsUser.find_by_id(params[:rails_user_id])
    if @rails_user == nil
      @journals = Journal.where(user_id: current_rails_user.id)
    elsif @rails_user != nil
      @journals = Journal.where(user_id: @rails_user.id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @journals, status: 200 }
      format.xml { render :xml => @journals, status: 200 }
    end
  end

  # GET /journals/1
  # GET /journals/1.json
  def show
    authorize! :manage, Journal
    authorize! :read, Journal

    respond_to do |format|
      format.html
      format.json { render :json =>  @journal, status: 200 }
      format.xml { render :xml => @journal, status: 200 }
    end
  end

  # GET /journals/new
  def new
    authorize! :manage, Journal
    @journal= Journal.new
  end

  # GET /journals/1/edit
  def edit
    authorize! :manage, Journal
  end

  # POST /journals
  # POST /journals.json
  def create
    authorize! :manage, Journal
    @journal = Journal.new(journal_params)
    @journal.user_id = current_rails_user.id
    
    respond_to do |format|
      if @journal.save
        if $PARSE_ENABLED

          # Create new Journal object then write atributes to Parse
          parse_journal = Parse::Object.new("Journal")
          parse_journal["journalEntry"] = @journal.journal_entry
          parse_journal["rails_user_id"] = @journal.user_id.to_s
          parse_journal["rails_id"] = @journal.id.to_s
          parse_journal["rails_sync_required"] = false
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

          # Set UserData entry for Journal Entry
          user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
            q.eq("UserID", parse_journal["user_id"])
            q.greater_than("createdAt", date_check_begin)
            q.less_than("createdAt", date_check_end)
          end.get.first

          if user_data == nil
            user_data = Parse::Object.new("UserData")
          end

          if user_data["Journal"] == nil
            user_data["Journal"] = Array.new
          end

          if user_data["Journal"].count < 1
            user_data["Journal"] = parse_journal.pointer
            user_data["UserID"] = parse_journal["user_id"]  
            user_data.save

            format.html { redirect_to journals_url, notice: 'Journal was successfully tracked.' }
            format.json { render :show, status: :created, location: sleeps_url }
          else
            parse_journal.parse_delete
            @journal.destroy
            format.html { redirect_to journals_url, notice: 'Journal Entry not created.  You already have one for this day.' }
          end
        elsif !$PARSE_ENABLED 
          format.html { redirect_to journals_url, notice: 'Journal was successfully tracked.' }
          format.json { render :show, status: :created, location: sleeps_url }
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
    authorize! :manage, Journal
    
    respond_to do |format|
      if @journal.update(journal_params)
        format.html { redirect_to journals_url, notice: 'Journal Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: journals_url }

        if $PARSE_ENABLED
          parse_journal = Parse::Query.new("Journal").eq("rails_id", @journal.id.to_s).get.first

          parse_journal["journalEntry"] = @journal.journal_entry
          parse_journal["rails_user_id"] = @journal.user_id.to_s
          parse_journal["rails_id"] = @journal.id.to_s
          parse_journal.save
        end

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
    authorize! :manage, Journal
    @journal.destroy
    
    respond_to do |format|
      if $PARSE_ENABLED
        parse_journal = Parse::Query.new("Journal").eq("rails_id", @journal.id.to_s).get.first
        user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
          q.eq("UserID", parse_journal["user_id"])
          q.eq("Journal", parse_journal.pointer)
        end.get.first

        user_data["Journal"] = nil
        user_data.save
        parse_journal.parse_delete

        if user_data["Mood"] == nil && user_data["Sleep"] == nil && user_data["SelfCare"] == nil && user_data["Journal"] == nil
          user_data.parse_delete
        end
      end

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

    def sync_new_rails_record(parse_journal)
      @journal = Journal.new

      if @rails_user == nil
        rails_user = current_user
      elsif @rails_user != nil
        rails_user = @rails_user
      end

      @journal.journal_entry = parse_journal["journal_entry"]
      @journal.user_id = rails_user.id
      @journal.save
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

      # Find the beginning of the same day as Mood Entry creation date
      # and the beginning of the next day.  This is to be used to find
      # dates in between... Meaning on the same day
      date_check_begin = parse_journal["createdAt"].to_date
      date_check_end =  date_check_begin.tomorrow
      date_check_begin = Parse::Date.new(date_check_begin)
      date_check_end = Parse::Date.new(date_check_end)

      # Set UserData entry for Self Care Entry
      user_data = user_data_query = Parse::Query.new("UserData").tap do |q|
        q.eq("UserID", parse_journal["user_id"])
        q.greater_than("createdAt", date_check_begin)
        q.less_than("createdAt", date_check_end)
      end.get.first

      if user_data == nil
        user_data = Parse::Object.new("UserData")
      end

      if user_data["Journal"] == nil
        user_data["Journal"] = Array.new
      end

      if user_data["Journal"] == nil
        user_data["Journal"] << parse_journal.pointer
        user_data["UserID"] = parse_journal["user_id"]
        user_data.save
      end
    end

    def sync_rails_record(parse_journal_rails_id)
      @journal = Journal.where(id: parse_journal_rails_id.to_i).first
      parse_journal = Parse::Query.new("Journal").eq("rails_id", parse_journal_rails_id.to_s).get.first

      @journal.journal_entry = parse_journal["journal_entry"]
      @journal.save
    end

    def sync_deleted_journal(rails_journal)
      @journal = Journal.where(id: rails_journal.id.to_i).first
      @journal.destroy
    end

    def sync_backends
      # Get all Journals for user
      if @rails_user == nil
        @journals = Journal.where(user_id: current_rails_user.id)
        @parse_journals = Parse::Query.new("Journal").eq("user_id", current_rails_user.parse_user_id.to_s).get
      elsif @rails_user != nil
        @journals = Journal.where(user_id: @rails_user.id)
        @parse_journals = Parse::Query.new("Journal").eq("user_id", @rails_user.parse_user_id.to_s).get
      end

      parse_unsynced_journals = []
      parse_deleted_journals = []

      # Find Parse Records with rails_sync_required = true
      @parse_journals.each do |p|
        if p["rails_sync_required"] == true
          parse_unsynced_journals.unshift(p)
        end
      end

      # Find Rails Records that no longer exist in Parse
      @journals.each do |r|
        if !@parse_journals.any? {|h| h["rails_id"] == r.id.to_s}
          parse_deleted_journals << r
        end
      end

      parse_unsynced_journals.each do |p|
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

      parse_deleted_journals.each do |r|
        sync_deleted_journal(r)
      end
    end
end