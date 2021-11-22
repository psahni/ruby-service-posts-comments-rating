require_relative '../../db/connection'

class PostService
  def self.call(env)
    req = Rack::Request.new(env)
    
    # GET POST /posts?id=2
    if req.params['id']
      post = Post.where(['id = ?', req.params['id']]).first;
      return post && req.get? ? respond_with_post(post) : bad_request
    end

    # GET TOP POSTs /posts?top=5
    if req.params['top']
      return req.get? ? respond_with_top_posts(req.params['top']) : bad_request
    end

    # GET TOP POSTs /posts?group_by=ip
    if req.params['group_by']
      return req.get? ? respond_with_grouped_by(req.params['group_by']) : bad_request
    end

    # GET POSTS /posts
    if req.get?
      return [200, Constants::CONTENT_TYPE, [Post.all.to_json]]
    end
    
    # CREATE POST /posts
    post = Post.new(req.params.merge({ip: req.ip}))
    return post.save ? respond_with_post(post) : unprocessable_entity(post)
  end

  class << self
    def respond_with_top_posts(top)
      [200, Constants::CONTENT_TYPE, [Post.top_posts(top).to_json]] 
    end
    
    def respond_with_grouped_by(group_by)
      case group_by
      when 'ip'
        return [200, Constants::CONTENT_TYPE, [Post.grouped_by_ip.to_json]]
      else
        return [200, Constants::CONTENT_TYPE, [[].to_json]]
      end
    end

    def respond_with_post(post)
      [200, Constants::CONTENT_TYPE, [post.to_json]]
    end

    def bad_request
      [400, Constants::CONTENT_TYPE, [JSON.generate({ status: 400, errors: "Bad Request" })]]
    end

    def unprocessable_entity(post)
      [422, Constants::CONTENT_TYPE, [JSON.generate({ status: 422, errors: post.errors.full_messages})]]
    end
  end
end
