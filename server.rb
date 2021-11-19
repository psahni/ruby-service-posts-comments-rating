require 'rack'
handler = Rack::Handler::Thin

class RackApp
  def call(env)
    req = Rack::Request.new(env)
    [200, {"Content-Type" => "text/plain"}, ["Hello from Rack - #{req.ip}"]]
  end
end


app = Rack::Builder.new do |builder|
  builder.use Rack::CommonLogger
  builder.run RackApp.new
end

handler.run app