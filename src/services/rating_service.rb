require_relative '../../db/connection'

class RatingService
  def self.call(env)
    req = Rack::Request.new(env)
    p req.params
    if req.get?
      return bad_request
    end
    
    if !req.params['post_id']
      return bad_request
    end
    
    Post.with_transaction do
      @post = Post.lock('FOR UPDATE NOWAIT').where(['id = ?', req.params['post_id']]).first;
      if @post
        @post = @post.update_rating(req.params['value'])
        @post_saved = @post.save
      else 
        return not_found
      end  
    end  # End Transaction
    
    return @post_saved ? respond_with_avg_rating(@post) : unprocessable_entity(@post) 
  end

  class << self
    def respond_with_avg_rating(post)
      [200, Constants::CONTENT_TYPE, [JSON.generate({ post_id: post.id, avg_rating: post.get_average_rating() })]]
    end

    def unprocessable_entity(post)
      [422, Constants::CONTENT_TYPE, [JSON.generate({ status: 422, errors: post.errors.full_messages})]]
    end

    def not_found
      [404, Constants::CONTENT_TYPE, [JSON.generate({ status: 404, errors: 'Post not found'})]] 
    end

    def bad_request
      [400, Constants::CONTENT_TYPE, [JSON.generate({ status: 400, errors: "Bad Request" })]]
    end
  end
end