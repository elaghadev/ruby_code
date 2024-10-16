require "rubygems"
require "rack"
require "minitest/autorun"
require File.expand_path("../lib/greeter", __FILE__)

describe Greeter do 
  before do
    @request = Rack::MockRequest.new(Greeter)
  end

  it "returns a 404 response for unknown requests" do
    _( @request.get("/unknown").status ).must_equal 404
  end

  it "/ displays Hello World by default" do 
    _( @request.get("/").body ).must_include "Hello World"
  end

  it "/ displays the name passed into the cookie" do 
    response = @request.get("/", "HTTP_COOKIE" => "greet=Ruby")
    _( response.body ).must_include "Hello Ruby"
  end

  it "/change sets cookie and redirects to root" do 
    response = @request.post("/change", params: { "name" => "Ruby" })
    _( response.status ).must_equal 302
    _( response["Location"] ).must_equal "/"
    _( response["Set-Cookie"] ).must_include "greet=Ruby"
  end
end
