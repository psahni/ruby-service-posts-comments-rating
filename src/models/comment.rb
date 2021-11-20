class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id


  validates :comment, :owner_id, :presence => true

  validate :feedback_for_post_or_user
  validate :feedback_to_self
  # validate :feedback_already_given

  def feedback_for_post_or_user
    if user_id.blank? && post_id.blank?
      self.errors.add(:base, 'Either post_id or user_id should not be blank')
    end
    if !user_id.blank? && !post_id.blank?
      self.errors.add(:base, 'Either post_id or user_id is accepted')
    end
  end

  def feedback_to_self
    if user_id == owner_id
      self.errors.add(:base, 'This request is not allowed')
    end
  end

  def feedback_already_given
    if !post_id.blank?
      comment = Comment.where(['post_id = ? AND owner_id = ?', post_id, owner_id]).first
    end
    if !user_id.blank?
      comment = Comment.where(['user_id = ? AND owner_id = ?', user_id, owner_id]).first
    end
    if (comment)
      self.errors.add(:base, 'Feedback already given')
    end
  end
end
