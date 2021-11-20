class Post  < ActiveRecord::Base
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
  
end