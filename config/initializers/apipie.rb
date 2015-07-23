Apipie.configure do |config|
  config.app_name                = "ThriveSync"
  config.copyright               = "&copy; 2015 ThriveStreams Inc."
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apidoc"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"

  config.app_info["1.0"] = "
    This documentation is for development use of the ThriveSync Platform.
  "
  config.authenticate = Proc.new do
     authenticate_or_request_with_http_basic do |username, password|
       username == "Neo" && password == "Th30n3"
    end
  end
end
