module RpushHelper

  def rpush_apn_create_app
    app = Rpush::Apns::App.new
    app.name = "thrivesync_ios_app"

    if (ENV['RAILS_ENV'] == 'development') || (ENV['RAILS_ENV'] == 'staging')
      app.certificate = File.read(Rails.root.join('config', 'certs', 'apns-dev.pem').to_s)
    elsif ENV['RAILS_ENV'] == 'production'
      app.certificate = File.read(Rails.root.join('config', 'certs', 'apns-prod.pem').to_s)
    end

    if (ENV['RAILS_ENV'] == 'development') || (ENV['RAILS_ENV'] == 'staging')
      app.environment = 'development'
    elsif ENV['RAILS_ENV'] == 'production'
      app.environment = 'production'
    end

    app.password = ENV['RPUSH_CERT_PASSWORD']
    app.connections = 1
    app.save!
  end

  def rpush_apn_notification(device_token, alert, data)
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name("thrivesync_ios_app")
    n.device_token = device_token
    n.alert = alert
    n.data = data
    n.save!
  end
end