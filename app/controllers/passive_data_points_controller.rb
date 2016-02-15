class PassiveDataPointsController < ApplicationController
  # TODO - Update Sample JSON Output
  resource_description do
    short 'Passive Data Point Entries'
    desc <<-EOS
      == Long description
        Passive Data Point Entries include:
          Required Fields:
            user_id: integer
            source_uuid: string
            creation_date_time: date
            schema_namespace: string
            schema_name: string
            schema_version: string
          Optional Fields:
            was_user_entered: boolean
            timezone: string
            external_uuid: string

      ===Sample JSON Output:
          {
            "moods": [
              {
                "id": 2712,
                "mood_rating": 4,
                "anxiety_rating": 1,
                "irritability_rating": 1,
                "timestamp": "2014-10-27 09:59:00 -0400",
                "created_at": "2014-10-27 05:59:41 -0400",
                "updated_at": "2014-10-27 05:59:41 -0400",
                "user_id": 24
              }
            ]
          }
    EOS
    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :passive_data_point_data do
    param :passive_data_point, Hash, :desc => "Passive Data Point", :required => false do
      param :source_uuid, :number, :desc => "Source Identification of Passive Data Point", :required => true
      param :creation_date_time, :undef, :desc => "Creation Date as defined from Source", :required => true
      param :schema_namespace, :undef, :desc => "Schema Namespace [String]", :required => true
      param :schema_name, :undef, :desc => "Schema Name [String]", :required => true
      param :schema_version, :undef, :desc => "Schema Version [String]", :required => true
    end
  end

  def_param_group :passive_data_points_all do
    param_group :passive_data_point_data
    param :was_user_entered, :undef, :desc => "User Entered Flag [Boolean]", :required => false
    param :timezone, :undef, :desc => "Timezone [String]", :required => false
    param :external_uuid, :undef, :desc => "External Source Identification of Passive Data Point [String]", :required => false
  end

  def_param_group :destroy_passive_data_point_data do
    param :id, :number, :desc => "Id of Passive Data Point to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :set_passive_data_point, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized, except: [:index]

  respond_to :html, :json

  def index
    @passive_data_points = PassiveDataPoint.all
    respond_with(@passive_data_points)
  end

  def show
    respond_with(@passive_data_point)
  end

  def new
    @passive_data_point = PassiveDataPoint.new
    respond_with(@passive_data_point)
  end

  def edit
  end

  def create
    @passive_data_point = PassiveDataPoint.new(passive_data_point_params)
    @passive_data_point.save
    respond_with(@passive_data_point)
  end

  def update
    @passive_data_point.update(passive_data_point_params)
    respond_with(@passive_data_point)
  end

  def destroy
    @passive_data_point.destroy
    respond_with(@passive_data_point)
  end

  private
    def set_passive_data_point
      @passive_data_point = PassiveDataPoint.find(params[:id])
    end

    def passive_data_point_params
      params.require(:passive_data_point).permit(:user_id, :integer, :was_user_entered, :boolean, :timezone, :string, :source_uuid, :string, :external_uuid, :string, :creation_date_time, :date, :schema_namespace, :string, :schema_name, :string, :schema_version, :string)
    end
end
