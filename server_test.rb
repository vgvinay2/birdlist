ENV['RACK_ENV'] = 'test'

require './server'
require 'test/unit'
require 'rack/test'
require 'byebug'

class BookListTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def json
    ActiveSupport::JSON.decode last_response.body
  end

  def app
    Sinatra::Application
  end

  def setup
    @bird             = Bird.new
    @bird.title       = "blue"
    @bird.type        = "String"
    @bird.description = "testing description"
    @bird.save
  end

  def test_create_fail1
    post 'api/v1/birds',{title: nil,type: "test type",description: "test description"}
    assert_equal "Invalid JSON", json["message"]
  end

  def test_create_fail2
    post 'api/v1/birds',{title: nil,type: " ",description: " "}
    assert_equal "Invalid JSON", json["message"]
  end

  def test_create_success
    post("api/v1/birds", {title: "test_title",type: "test type",description: "test description"}.to_json )
    assert_equal "test_title",       json["title"]
    assert_equal "test type",        json["type"]
    assert_equal "test description", json["description"]
  end

  # def test_index
  #   get "api/v1/birds"
  #   assert_equal true, true
  # end

  def test_show_success
    get "api/v1/birds/#{@bird.id.to_s}"
    assert_equal true,                  json.present?
    assert_equal "blue",                json["title"]
    assert_equal "String",              json["type"]
    assert_equal "testing description", json["description"]
  end
  
  def test_show_fail
    get "api/v1/birds/nil"
    assert_equal "Bird Not Found", json["message"]
    assert_equal 404,              json["status"]
  end
   
  def test_delete_success
    delete "api/v1/birds/#{@bird.id.to_s}"
    assert_equal "Bird has been deleted Successfully!", json["message"]
    assert_equal 200,                                   json["status"]
  end

   def test_delete_fail
    delete "api/v1/birds/nil"
    assert_equal "Bird Not Found", json["message"]
    assert_equal 404,              json["status"]
  end

end