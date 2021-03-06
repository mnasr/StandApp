require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  use_transactional_fixtures = true
  use_instantiated_fixtures = false
 
  fixtures :all
end

class ActionController::TestCase
  include Devise::TestHelpers
end
