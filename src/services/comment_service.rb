require_relative '../../db/connection'

class CommentService
  def self.call(env)
    req = Rack::Request.new(env)
    if req.post?
      p req.params
      comment = Comment.new(req.params)
      if comment.save
        return respond_with_all_feedbacks_by_owner(comment)
      else
        return [422, Constants::CONTENT_TYPE, [JSON.generate({ status: 422, errors: comment.errors.full_messages})]]
      end
    end
  end


  class << self
    def respond_with_all_feedbacks_by_owner(comment)
      [200, Constants::CONTENT_TYPE, [User.feedback_list(comment.owner_id).to_json]]
    end
  end
end