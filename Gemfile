source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.3'

gem 'pg'

gem 'prawn'
gem 'prawn-fast-png'
gem 'ancestry'
gem 'russian'
gem 'draper'
gem 'sass-rails', '~> 4.0.1'

gem 'plupload-rails', github: 'gucki/plupload-rails'

gem 'coffee-rails', '~> 4.0.1'
gem 'therubyracer',  platform: 'ruby'

gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'sugar-rails'

# to parse youtube and links
gem 'auto_html'
gem 'rails_autolink'

# markdown
gem 'rdiscount'

gem 'rails_config'

gem "compass-rails", github: 'Compass/compass-rails', branch: '2-0-stable'
gem "selectize-rails"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

gem 'unicorn'

# Request sanitizer.
#
gem 'rack-utf8_sanitizer'

# We use slim for all the templates.
#
gem 'slim'

gem 'role-rails' # TODO replace with evil-front

gem 'oj'

# Exception reporting.
#
gem 'honeybadger'


# Authentication and authorization.
#
gem "devise", "~> 3.1.0"
gem 'devise-encryptable'

gem 'cancan'

gem 'carrierwave'
gem 'carrierwave-meta'
gem 'fog', '~> 1.3.1'
gem 'mini_magick'
gem 'rmagick', require: false

gem 'whenever'

# Scheduling and processing.
#
# gem 'sidekiq', '~> 2.9.0'
# gem 'sidekiq-failures'

# Sidekiq uses Sinatra for status page.
#
# gem 'sinatra', '>= 1.3.0', :require => nil


gem 'recursive-open-struct'
gem 'simple_form'

gem 'kaminari'
gem 'enumerize', github: 'brainspec/enumerize'

group :development, :test do
  # rspec-rails must be in development group as well for `rake spec' to work
  gem 'rspec-rails'

  # Allows invoking binding.pry from failing specs.
  gem 'pry'
  gem 'pry-rails'

  gem 'ffaker'
end

group :development do
  gem 'letter_opener'
  gem 'ruby-prof'

  gem 'better_errors'
  gem 'binding_of_caller'

  # Capistrano and friends
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano-detect-migrations'
  gem 'capistrano-nc'
  gem 'capistrano_colors'
  gem 'capistrano-rbenv'

  gem 'quiet_assets'

  # Mailcatcher is used on staging to debug e-mail.
  # is depends on sqlite3, so it doesn't work on heroku
  gem 'mailcatcher', github: 'sj26/mailcatcher'
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-summary'

  gem 'fuubar'
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'pdf-reader', require: false
end
