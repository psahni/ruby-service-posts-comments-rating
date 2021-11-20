class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
end