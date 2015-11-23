class Analytics
  class_attribute :backend
  self.backend = AnalyticsRuby

  def initialize(user, client_id = nil)
    @user = user
    @client_id = client_id
  end

  def track_user_creation
    identify
    track(
      {
        user_id: user.id,
        event: 'Create User',
        properties: {
          city_state: user.zip.to_region
        }
      }
    )
  end

  def track_user_sign_in
    identify
    track(
      {
        user_id: user.id,
        event: 'Sign In User'
      }
    )
  end

  def track_user_logout
    identify
    track(
      user_id: user.id,
      event: 'Logged Out',
      properties: {
      }
    )
  end

  def track_device_created(device)
    identify
    track(
      user_id: user.id,
      event: 'Device Entry Created',
      properties: {
        device_id: device.id,
        device_enabled: device_enabled,
        device_user_id: device.user_id,
        device_platform: device.platform
      }
    )
  end

  def track_device_updated(device)
    identify
    Analytics.track(
      user_id: user.id,
      event: 'Device Entry Updated',
      properties: {
        device_id: device.id,
        device_enabled: device_enabled,
        device_user_id: device.user_id,
        device_platform: device.platform
      }
    )
  end

  def track_device_deleted
    identify
    track(
      user_id: current_user.id,
      event: 'Device Entry Deleted',
      properties: {
      }
    )
  end

  private

  def identify
    backend.identify(identify_params)
  end

  attr_reader :user, :client_id

  def identify_params
    {
      user_id: user.id#,
      #traits: user_traits
    }
  end

  def user_traits
    {
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      city_state: user.city_state,
    }.reject { |key, value| value.blank? }
  end

  def track(options)
    if client_id.present?
      options.merge!(
        context: {
          'Google Analytics' => {
            clientId: client_id
          }
        }
      )
    end
    backend.track(options)
  end
end