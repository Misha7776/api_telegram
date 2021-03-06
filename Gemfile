source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use Json Web Token (JWT) for token based authentication
gem 'jwt'
# Lightweight client for bot API
gem 'telegram-bot'
# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'sidekiq'
gem 'r_creds'
gem 'redis-rails', '~> 5'
gem 'redis-namespace'
gem 'oj'
gem 'blueprinter'
gem 'pagy'
gem 'api-pagination'
gem 'apitome'
gem 'rack-cors'
gem 'rails-i18n'
gem 'rspec_api_documentation'
gem 'devise-jwt'
gem 'secure_credentials'
gem 'faker'
gem 'httparty'
gem 'rails_db'
gem 'sentry-raven'
gem 'axlsx', '2.1.0.pre'
gem 'axlsx_rails'
gem 'paper_trail'
gem 'scout_apm'

group :development, :test do
  gem 'dotenv'
  gem 'rails-erd'
  gem 'pry'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'rubocop'
  gem 'rubycritic'
  gem 'brakeman'
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-sidekiq'
  gem 'vcr'
  gem 'fakeredis'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
