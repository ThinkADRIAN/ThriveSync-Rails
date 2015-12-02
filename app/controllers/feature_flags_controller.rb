class FeatureFlagsController < ApplicationController
  require 'json'

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!

  respond_to :json

  def feature_flags
    authorize current_user

    peer_support_enabled = $flipper[:peer_support].enabled? current_user
    provider_support_enabled = $flipper[:provider_support].enabled? current_user

    feature_flags_json = {
      peer_support: peer_support_enabled,
      provider_support: provider_support_enabled
    }

    respond_to do |format|
      format.json {
        render json: JSON.pretty_generate(feature_flags_json)
      }
    end
  end
end