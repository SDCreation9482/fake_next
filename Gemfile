source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.6"

gem "rails", "~> 7.0.8", ">= 7.0.8.7"
gem "puma", "~> 5.6.7"
gem "sqlite3", "~> 1.4"
gem "mysql2", "~> 0.5.6"
gem "turbo-rails"
gem "stimulus-rails"
gem "importmap-rails"
gem "sass-rails", "~> 6.0"
gem "sprockets-rails"
gem "bootsnap", require: false

gem "redis", "~> 4.2.5"
gem "httparty"
gem "actiontext"
gem "active_model_serializers", "~> 0.10.15"
gem "devise"
gem "pundit"
gem "friendly_id"
gem "paper_trail", "~> 13.0"
gem "enumerize"
gem "jwt"
gem "omniauth", "~> 2.1"
gem "omniauth-oauth2", "~> 1.6"
gem "prometheus-client", "~> 3.0"
gem "resque", "~> 2.7"
gem "resque-scheduler", "~> 4.11"
gem "cocoon"
gem "smarter_csv", "~> 1.13"
gem "roo"
gem "write_xlsx"
gem "nokogiri", "~> 1.18.3"
gem "oj", "~> 3.16.9"
gem "simple_form"
gem "responders"
gem "rubocop"
gem "uglifier", "~> 4.2.0"
gem "actionpack"
gem "actionmailer"
gem "actionmailbox"
gem "actioncable"

group :development, :test do
  gem "byebug", platforms: %i[ mri mingw x64_mingw ]
  gem "capybara"
  gem "selenium-webdriver"
  gem "rspec-rails", "~> 4.0.1"
  gem "shoulda-matchers", "~> 4.4"
  gem "factory_bot_rails"
  gem "faker", "~> 2.15"
end

group :development do
  gem "web-console", ">= 4.2.1"
  gem "listen", "~> 3.9"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
end
