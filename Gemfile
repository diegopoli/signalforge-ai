source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "pgvector"
gem "puma", ">= 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "tailwindcss-rails"
gem "devise"
gem "redis", ">= 5.0"
gem "sidekiq"
gem "sidekiq-cron"
gem "ruby-openai"
gem "httparty"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "dotenv-rails"
  gem "rspec-rails"
  gem "factory_bot_rails"
end

group :development do
  gem "foreman"
  gem "web-console"
end
