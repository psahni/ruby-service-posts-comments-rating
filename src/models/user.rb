class User < ActiveRecord::Base
  validates :username, :presence => true

  has_many :posts
  
  has_many :post_feedbacks,
          -> {where('comments.post_id is NOT NULL AND comments.user_id is NULL')},
          :foreign_key => :owner_id,
          :class_name => 'Comment'
  
  has_many :user_feedbacks,
          -> {where('comments.post_id is NULL AND comments.user_id is NOT NULL')},
          :foreign_key => :owner_id,
          :class_name => 'Comment'
 
  has_many :feedbacks, 
           :foreign_key => :owner_id,
           :class_name => 'Comment'

          
  def self.feedback_list(owner_id)
    user = where(username: owner_id).includes(:feedbacks).first
    user.feedbacks
  end
end
