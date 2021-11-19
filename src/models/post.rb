class Post  < ActiveRecord::Base
  belongs_to :user, :foreign_key => :username
  validates :username, :title, :content, :presence => true

  after_save :create_user

  def create_user
    p self
    user = User.where(username: self.username).first
    if !user
      user = User.create(username: self.username)
      p user
    end
  end
end