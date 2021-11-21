class Post < ActiveRecord::Base
  attr_accessor :ratings_value
  attr_writer :is_update_rating

  belongs_to :user, :foreign_key => :username
  validates :username, :title, :content, :presence => true

  validates :ratings_value, 
            numericality: { greater_than: 0, less_than_or_equal_to: 5 },  
            if: Proc.new { |a| a.is_update_rating && !a.ratings_value.blank? }
  
  after_save :create_user

  validate :validate_rating

  def create_user
    user = User.where(username: self.username).first
    if !user
      user = User.create(username: self.username)
    end
  end

  def is_update_rating
    @is_update_rating ||= false
  end

  def get_average_rating
    (ratings_sum/ratings_count.to_f).round(1)
  end

  def validate_rating
    if is_update_rating && ratings_value.blank?
      self.errors.add(:ratings_value, "can't be blank")
    end
  end

  def update_rating(value)
    self.is_update_rating = true
    self.ratings_value = value
    return self if ratings_value.blank?
    self.ratings_sum = self.ratings_sum + self.ratings_value.to_i
    self.ratings_count = self.ratings_count + 1
    self
  end

  def self.with_transaction(&block)
    ActiveRecord::Base.transaction(isolation: :read_committed) do
      block.call
    end
  end

  def self.top_posts(top)
    return [] if top.blank? or top.to_i == 0
    select("id, content, ROUND((ratings_sum+0.0)/(ratings_count+0.0), 1) as avg_rating").order("avg_rating DESC").limit(top)
  end

  def self.grouped_by_ip
    grouped_data = {};
    posts = Post.select("ip, username").group("ip, username");
    posts.each do |post|
      grouped_data[post.ip] = (grouped_data[post.ip] || []).push(post.username)
    end
    grouped_data
  end
end

