require 'rack'
require 'json'

require './src/services/post_service'

handler = Rack::Handler::Thin

class RackApp
  def call(env)
    req = Rack::Request.new(env)
    [200, {"Content-Type" => "text/plain"}, ["Hello from Rack - #{req.ip}"]]	
  end
end

app = Rack::Builder.new do |builder|
  builder.use Rack::CommonLogger
  map "/posts" do
    use Rack::Lint
    run PostService
  end
  map "/ratings" do
    use Rack::Lint
    run RatingService
  end
  builder.run RackApp.new
end

handler.run app