require_relative '../../db/connection'

class RatingService
    def self.call(env)
		req = Rack::Request.new(env)
    p req.params
		if req.get?
			return [400, Constants::CONTENT_TYPE, [JSON.generate({ status: 400, errors: "Bad Request" })]]
		else
      if !req.params['post_id']
        return [400, Constants::CONTENT_TYPE, [JSON.generate({ status: 400, errors: "Bad Request" })]]
      end
      post = Post.where(['id = ?', req.params['post_id']]).first;
      if post
        post = post.update_rating(req.params['value'])
        if post.save
          return [200, Constants::CONTENT_TYPE, [JSON.generate({ avg_rating: post.get_average_rating() })]]
        else
          return [422, Constants::CONTENT_TYPE, [JSON.generate({ status: 422, errors: post.errors.full_messages})]]   
        end
      else 
        return [404, Constants::CONTENT_TYPE, [JSON.generate({ status: 404, errors: 'Post not found'})]] 
      end
    end	
	end
end