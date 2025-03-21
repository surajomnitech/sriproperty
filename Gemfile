source "https://rubygems.org"

ruby "3.2.1"

# Core Rails gems
gem "rails", "~> 7.1.5", ">= 7.1.5.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"

# Authentication & Authorization
gem "devise", "~> 4.9"
gem "pundit", "~> 2.3"

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

# Utilities
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
  # Uncomment if needed for performance profiling
  # gem "rack-mini-profiler"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
