require_relative '../../db/connection'

class PostService
    def self.call(env)
		req = Rack::Request.new(env)
		if req.get?
			[200, { "Content-Type" => "application/json" }, [Post.all.to_json]]
		else
				post = Post.new(req.params)
				if post.save
					return [200, { "Content-Type" => "application/json" }, [JSON.generate(post)]] 
				else 
					return [422, { "Content-Type" => "application/json" }, [JSON.generate({ status: 422, errors: post.errors.full_messages})]] 
				end
			end	
	end
end