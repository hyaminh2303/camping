source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry', '~> 0.14.1'

  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker', '~> 2.17'
  gem 'database_cleaner-active_record'
  gem 'letter_opener_web', '~> 1.4'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'annotate', '~> 3.1', '>= 3.1.1'
  gem 'rails-erd', '~> 1.6', '>= 1.6.1'

  gem 'capistrano', '~> 3.16.0', require: false
  gem 'capistrano-rails', '~> 1.6', '>= 1.6.1'
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-passenger', '~> 0.2.1'
  gem 'capistrano-sidekiq', '~> 2.0'
end

group :staging do
  gem 'letter_opener_web', '~> 1.4'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'slim-rails', '~> 3.2'
gem 'simple_form', '~> 5.0', '>= 5.0.3'
# gem 'bootstrap', '~> 4.6'
gem 'settingslogic', '~> 2.0', '>= 2.0.9'
gem 'paranoia', '~> 2.4', '>= 2.4.3'
gem 'js-routes', '~> 1.4', '>= 1.4.14'
gem 'devise', '~> 4.8'
gem 'bootstrap4-kaminari-views', '~> 1.0', '>= 1.0.1'
gem 'kaminari', '~> 1.2', '>= 1.2.1'

gem 'active_hash', '~> 3.1'
gem 'enumerize', '~> 2.4'

gem 'carrierwave', '~> 2.0'
gem 'fog-aws', '~> 3.10'
gem 'figaro', '~> 1.2'
gem 'faraday', '~> 1.4', '>= 1.4.3'
gem 'validates_timeliness', '~> 6.0.0.alpha1'
gem 'whenever', require: false
gem "rolify"
gem 'cancancan', '~> 3.3'
gem 'ransack', '~> 2.4', '>= 2.4.2'
gem 'cocoon', '~> 1.2', '>= 1.2.15'
gem 'acts_as_tenant', '~> 0.5.0'
gem 'acts-as-taggable-on', '~> 8.1'
gem 'ckeditor', '~> 5.1'
gem 'mini_magick', '~> 4.11'
gem 'jsonb_accessor', '~> 1.3', '>= 1.3.2'
gem 'globalize', '~> 6.0', '>= 6.0.1'
gem 'globalize-accessors', '~> 0.3.0'
gem 'globalize-validations', '~> 1.0'
gem 'truncate_html', '~> 0.9.3'
gem 'wannabe_bool', '~> 0.7.1'
gem 'active_model_serializers', '~> 0.10.12'
gem "gmo"
gem 'simple_calendar', '~> 2.4', '>= 2.4.3'
gem "validate_url"
gem 'faraday_middleware', '~> 1.2'
gem 'exception_notification', '~> 4.4', '>= 4.4.3'
gem 'premailer-rails', '~> 1.9', '>= 1.9.2'
gem 'deepl-rb', require: 'deepl'
gem 'meta-tags', '~> 2.16'
gem 'i18n-js', '~> 3.5.1'
