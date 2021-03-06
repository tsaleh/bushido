ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'action_view/test_case'

begin require 'redgreen'; rescue LoadError; end

%w(master_may_i).each do |gem|
  Dir[File.join(Gem.loaded_specs[gem].full_gem_path, 'shoulda_macros', '*')].each do |shoulda_file|
    require shoulda_file
  end
end

FakeWeb.allow_net_connect = false

Mocha::Configuration.warn_when(:stubbing_non_existent_method)
Mocha::Configuration.warn_when(:stubbing_non_public_method)

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  stub_all_s3_for_paperclip_model(User)
end

class ActionView::TestCase
  class TestController < ActionController::Base
    attr_accessor :request, :response, :params
 
    def initialize
      @request = ActionController::TestRequest.new
      @response = ActionController::TestResponse.new
      
      # TestCase doesn't have context of a current url so cheat a bit
      @params = {}
      send(:initialize_current_url)
    end
  end
end

class ActionController::TestCase
  include Webrat::Matchers
  def response_body
    @response.body
  end
end
