source 'https://rubygems.org'

ruby '2.2.4'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'paperclip', '~> 3.0'
# gem 'sequel'
gem 'nokogiri'

gem 'haml-rails'

gem 'hashdiff'

gem 'mailgun_rails'
gem 'rails_email_preview', '~> 2.0.1'

gem 'business_time'
gem 'holidays'

gem 'amorail'

gem 'bootstrap-sass'
gem 'font-awesome-sass', '~> 4.6.2'
gem 'simple_form'

gem 'sidekiq'
gem 'redis'
gem 'sinatra', require: false
gem 'active_job_status'
gem 'redis-rails'
gem 'readthis'
gem 'hiredis'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'rubocop', require: false
  gem 'haml-lint', require: false
  gem 'meta_request'
end

gem 'puma'

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end
