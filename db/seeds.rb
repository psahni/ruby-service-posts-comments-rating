require 'faker'

require_relative './connection'
require_relative '../src/models/post'

@fake_ips = %w( 
13.217.99.238
184.144.125.131
230.142.29.79
197.236.165.246
146.52.191.32
75.94.233.251
8.255.247.142
91.95.113.192
131.10.38.60
177.126.141.36
6.24.197.20
91.163.67.169
248.22.72.212
104.4.92.226
253.78.191.103
58.176.48.12
164.79.58.172
29.67.216.232
175.100.44.112
210.183.175.190
69.69.29.114
104.74.238.7
149.80.14.106
5.210.118.202
185.186.172.11
142.218.82.91
14.22.12.198
45.2.49.229
34.187.70.149
44.114.91.2
189.223.171.251
15.210.149.81
155.37.84.23
16.130.34.132
234.251.43.105
169.76.40.114
11.69.55.132
164.250.106.139
238.61.84.144
95.20.87.84
245.120.66.110
6.121.65.119
252.232.168.15
234.5.225.159
203.170.194.242
111.118.123.97
229.5.219.29
161.204.102.221
71.126.252.193
71.177.219.165
)

def create_post
  p @fake_ips
  (1..50000).each do |i|
    puts "Creating Post #{i}"
    post = Post.new({
      username: Faker::Name.unique.name.gsub(/\s+/, '').downcase,
      title: Faker::Lorem.word,
      content: Faker::Lorem.paragraph(sentence_count: 5),
      ratings_sum: rand(90..210),
      ratings_count: rand(45..50),
      ip: @fake_ips[rand(@fake_ips.length)]
    })

    post.save!
  end
end

def create_post_feedbacks
  owners = User.all.map(&:username)
  (1..9900).each do |i|
    puts "Creating Comment #{i}"
    comment = Comment.new({
      owner_id: owners[rand(1..owners.length-1)],
      post_id: rand(1..Post.count),
      comment: Faker::Lorem.paragraph(sentence_count: 2),
      user_id: nil
    })

    comment.save!
  end
end

def create_user_feedbacks
  owners = User.all.map(&:username)
  (1..50).each do |i|
    puts "Creating Comment #{i}"
    comment = Comment.new({
      owner_id: owners[rand(1..owners.length-1)],
      post_id: nil,
      comment: Faker::Lorem.paragraph(sentence_count: 2),
      user_id: owners[rand(1..owners.length-1)]
    })

    if comment.user_id == comment.owner_id
      comment.user_id = owners[rand(1..owners.length-1)]
    end
    comment.save!
  end
end


case ARGV[0]
when 'post'
  create_post
when 'post_feedback'
  create_post_feedbacks
when 'user_feedback'
  create_user_feedbacks
end

#  ruby db/seeds.rb user_feedback 