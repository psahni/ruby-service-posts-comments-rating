require 'net/http'

module Helpers
  attr_reader :status, :response

  ROOT = File.expand_path(File.dirname(__FILE__) + "/..")


  def GET(path, header={})
    Net::HTTP.start(@host, @port) { |http|
      get = Net::HTTP::Get.new(path, header)
      http.request(get) { |response|
        @status = response.code.to_i
        if response.content_type == "text/yaml"
          load_yaml(response)
        else
          @response = response
        end
      }
    }
  end


  def POST(path, formdata={}, header={})
    Net::HTTP.start(@host, @port) { |http|
      post = Net::HTTP::Post.new(path, header)
      post.form_data = formdata
      http.request(post) { |response|
        @status = response.code.to_i
        @response = response.body
      }
    }
  end
end
