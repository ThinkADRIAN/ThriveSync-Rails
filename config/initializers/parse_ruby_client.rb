require 'parse-ruby-client'

$parse_client = Parse.init :application_id => ENV["PARSE_APPLICATION_ID"],
                           :api_key        => ENV["PARSE_API_KEY"]