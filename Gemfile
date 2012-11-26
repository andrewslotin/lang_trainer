source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'origin'
gem 'moped'
gem 'mongoid'
gem 'bson_ext'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'haml'
gem 'haml-rails'
gem 'inherited_resources'
gem 'cancan'
gem 'unicode'
gem 'nokogiri'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'bootstrap-sass'
gem 'jquery-rails'

group :development do
  gem 'puma'
  gem 'awesome_print'
  gem 'guard-spork'
  gem 'guard-rspec'
end

group :test do
  if RUBY_PLATFORM[/darwin/i]
    gem 'growl', require: false
    gem 'rb-fsevent', require: false
    gem 'growl-rspec', require: false
  end
  gem 'capybara', '~> 1.0'
  gem 'spork-rails'
  gem 'faker'
  gem 'steak'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end