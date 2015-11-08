source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'

group :development, :test do
# Use sqlite3 as the database for Active Record
#	gem 'sqlite3'
end
group :development, :staging do
  gem 'database_cleaner'
end
group :production, :staging do
  gem 'rails_12factor'
end

gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
# gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Authentication
gem 'devise',           '>= 2.0.0'
gem 'devise_invitable', '~> 1.3.4'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-linkedin'
gem 'omniauth-google-oauth2'
gem 'simple_token_authentication', '~> 1.0'

# Authorization
gem 'cancancan', '~> 1.10'
gem 'pundit'

# Graphing
gem 'chartkick'
gem 'groupdate'

# Email Services
gem 'mandrill-api'

# Friendships
# gem 'amistad'
gem 'has_friendship'

# Data Generator
gem 'faker'

# ENV Variable Handling
gem 'figaro'

# Styling
gem 'designmodo-startup_framework-rails'
gem 'less-rails-bootstrap'
gem 'less-rails'
gem 'font-awesome-rails'
gem 'will_paginate'
gem 'chosen-rails'
gem 'bootstrap-material-design'

# Interface
gem 'jquery-ui-rails'
gem 'jquery-slick-rails'
gem 'touchpunch-rails'

# Messaging
gem 'mailboxer'

# Analytics
gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'

# Parse Platform Client
gem 'parse-ruby-client'

# Background Job Processing
gem 'sucker_punch', '~> 1.0'

# Feature Flags
gem 'flipper'
gem 'flipper-activerecord3dot2'
gem 'flipper-ui'

# Testing
group :development, :test do
gem 'rspec-rails'
gem 'factory_girl_rails'
gem 'capybara'
gem 'guard-rspec'
gem 'spring-commands-rspec'
gem 'vcr'
end
group :test do
gem 'webmock'
end

# Static Pages
gem 'high_voltage', '~> 2.4.0'

#Api gems
gem 'active_model_serializers'
gem 'apipie-rails', github: 'Apipie/apipie-rails', ref: '928bd858fd14ec67eeb9483ba0d43b3be8339608'
