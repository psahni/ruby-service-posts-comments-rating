require_relative '../db/connection'
require_relative '../src/models/post'

require 'builder'

class FeedbackJob
  def run
    sql = "
      comments.id, user_id, post_id, owner_id, comment, 
      ROUND((ratings_sum+0.0)/(ratings_count+0.0), 1) as rating, 
      case when post_id is not null then 'Post' when user_id is not null then 'User' else 'Other' end as Feedback_Type
    "
    @comments = Comment.select(sql).left_outer_joins(:post)
  end


  def generate_xml
    run
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "ASCII"  
    xml.comments do
      @comments.each do |comment|
        xml.comment do |xp|
          xp.owner comment.owner_id
          xp.comment comment.comment
          xp.rating comment.rating
          xp.feedback_type comment.feedback_type
        end
      end
    end
  end

  def write_to_file(xml)
    File.write('feedbacks_xml.xml', xml)
  end
end
