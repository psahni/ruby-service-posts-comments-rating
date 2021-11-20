class User < ActiveRecord::Base
  validates :username, :presence => true

  has_many :posts
  has_many :comments, foreign_key: :owner_id
end