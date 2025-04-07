source "https://rubygems.org"

ruby "3.2.1"

# Core Rails gems
gem "rails", "~> 7.1.5", ">= 7.1.5.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"
gem "importmap-rails"

# Authentication & Authorization
gem "devise", "~> 4.9.3"
gem "pundit", "~> 2.3"
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"

# Background Processing & Caching
gem "redis", ">= 4.0.1"
gem "sidekiq", "~> 7.0"

# File Upload & Image Processing
gem "image_processing", "~> 1.2"
gem "aws-sdk-s3", "~> 1.132"

# Search
gem "elasticsearch-rails", "~> 7.2"
gem "elasticsearch-model", "~> 7.2"

# Phone Number Handling
gem "phonelib", "~> 0.8"

# Pagination
gem "pagy", "~> 6.2"
gem 'kaminari', '~> 1.2.2'

# Utilities
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails"
  gem "faker"
end

gem 'dotenv-rails', groups: [:development, :test]

group :development do
  gem "web-console"
  # Uncomment if needed for performance profiling
  # gem "rack-mini-profiler"
  # Preview email in the browser instead of sending it
  gem "letter_opener"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end