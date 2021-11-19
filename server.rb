require 'rack'
require 'json'
handler = Rack::Handler::Thin

class RackApp
  def call(env)
    req = Rack::Request.new(env)
		[200, {"Content-Type" => "text/plain"}, ["Hello from Rack - #{req.ip}"]]	
	end
end


class Heartbeat
	def self.call(env)
		req = Rack::Request.new(env)
		if req.get?
			[200, { "Content-Type" => "text/plain" }, ["OK Bhai"]]
		else
			[200, { "Content-Type" => "application/json" }, [JSON.generate({name: 'Prashant'})]] 
		end	
	end
end

app = Rack::Builder.new do |builder|
  builder.use Rack::CommonLogger
		map "/posts" do
			use Rack::Lint
			run Heartbeat
		end
		
		map '/' do
			
		end
  builder.run RackApp.new
end

handler.run app