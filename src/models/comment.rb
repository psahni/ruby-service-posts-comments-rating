class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id


  validates :comment, :owner_id, :presence => true

  validate :feedback_for_post_or_user


  def feedback_for_post_or_user
    if user_id.blank? && post_id.blank?
      self.errors.add(:base, 'Either post_id or user_id should not be blank')
    end
    if !user_id.blank? && !post_id.blank?
      self.errors.add(:base, 'Either post_id or user_id is accepted')
    end
  end
end
