require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'database_cleaner'
  require 'factory_girl'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
  end

  OmniAuth.config.test_mode = true
end

Spork.each_run do
  FactoryGirl.reload
end