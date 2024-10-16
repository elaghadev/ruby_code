require 'rack'
require 'rack/reloader'
require './lib/greeter'

use Rack::Reloader, 0
use Rack::Auth::Basic, "Protected Area" do |username, password|
  password == "secret"
end

use Rack::Static, urls: ["/stylesheets"], root: "public"

run Rack::Cascade.new([Greeter])


