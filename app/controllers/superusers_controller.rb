class SuperusersController < ApplicationController
  before_action :authenticate_user!

  def export_research_csv
    csv_type = params[:type]
    @research_users = User.where.not(research_started_at: nil)
    @moods = []
    @sleeps = []
    @self_cares = []
    @journals = []

    @research_users.each do |research_user|
      @moods += research_user.moods
      @sleeps += research_user.sleeps
      @self_cares += research_user.self_cares
      @journals += research_user.journals
    end

    respond_to do |format|
      case csv_type
        when 'moods'
          format.csv { render text: @moods.to_csv }
        when 'sleeps'
          format.csv { render text: @sleeps.to_csv }
        when 'self_cares'
          format.csv { render text: @self_cares.to_csv }
        when 'journals'
          format.csv { render text: @journals.to_csv }
      end
    end
  end
end
