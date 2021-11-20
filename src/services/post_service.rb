require_relative '../../db/connection'

class PostService
  def self.call(env)
    req = Rack::Request.new(env)
    # GET POST /posts?id=2
    if req.params['id']
      post = Post.where(['id = ?', req.params['id']]).first;
      if post && req.get?
        return respond_with_post(post)
      else
        return bad_request
      end
    end
    # GET TOP POSTs /posts?top=5
    if req.params['top']
      return req.get? ? respond_with_top_posts(req.params['top']) : bad_request
    end
    # GET POSTS /posts
    if req.get?
      return [200, Constants::CONTENT_TYPE, [Post.all.to_json]]
    else
      # CREATE POST /posts
      post = Post.new(req.params)
      if post.save
        return respond_with_post(post)
      else 
        return [422, Constants::CONTENT_TYPE, [JSON.generate({ status: 422, errors: post.errors.full_messages})]]
      end
    end
  end

  class << self
    def respond_with_top_posts(top)
      [200, Constants::CONTENT_TYPE, [Post.top_posts(top).to_json]] 
    end
    
    def respond_with_post(post)
      [200, Constants::CONTENT_TYPE, [post.to_json]]
    end

    def bad_request
      [400, Constants::CONTENT_TYPE, [JSON.generate({ status: 400, errors: "Bad Request" })]]
    end
  end
end
