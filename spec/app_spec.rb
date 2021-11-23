require 'thin'

require_relative './spec_helper'
require_relative '../app'


describe App do
  include Helpers

  
  before(:all) do
    @host = '127.0.0.1'
    @port = 8080
    @app = App.build

    @server = Thin::Server.new(@host, @port, @app)
   
    
    Thread.new {  
      @server.start
    }
    Thread.pass until @server.running?
  end

  after(:all) do
    @server.stop
    Thread.pass if @server.running?
  end

  it ('should access root url') do
    GET('/')
    expect(response.code).to eq('200')
  end

  describe '/posts' do

    after do
      Post.where(username: 'psTest').delete_all
      User.where(username: 'psTest').delete_all
    end

    it ('should get me all posts') do
      post = Post.create!({
        username: 'psTest',
        title: 'My Post',
        content: 'My content',
        ratings_sum: rand(90..210),
        ratings_count: rand(45..50),
        ip: '127.0.0.1'
      })

      GET('/posts')
      
      posts = JSON.parse(response.body)
      post = Post.find(post.id)

      expect(posts).to_not be_empty
      expect(post).to_not be_nil
    end

    it ('should create a post') do
      POST("/posts", {
        title: 'Test: my title post', 
        content: 'Test: my conent', 
        username: 'psTest'
      })

      expect(status).to eq(200)
      post = JSON.parse(response)
      expect(post).to_not be_nil
    end
  end
end
