require_relative '../../db/connection'

class PostService
  def self.call(env)
    req = Rack::Request.new(env)
    # GET POST /posts?id=2
    if req.params['id']
      post = Post.where(['id = ?', req.params['id']]).first;
      if post && req.get?
        return [200, Constants::CONTENT_TYPE, [post.to_json]] 
      else
        return [404, Constants::CONTENT_TYPE, [JSON.generate({ status: 404, errors: 'Post not found'})]]
      end
    end
    # GET POSTS /posts
    if req.get?
      [200, Constants::CONTENT_TYPE, [Post.all.to_json]]
    else
      # CREATE POST /posts
      post = Post.new(req.params)
      if post.save
        return [200, Constants::CONTENT_TYPE, [post.to_json]]
      else 
        return [422, Constants::CONTENT_TYPE, [JSON.generate({ status: 422, errors: post.errors.full_messages})]]
      end
    end
  end
end