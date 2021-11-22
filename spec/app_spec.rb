require 'net/http'
require_relative '../app'

SERVER = 'localhost'


describe App do
  describe Post do 
    it ('should get me posts') do
      path = '/';
      get = Net::HTTP::Get.new(path, {})
      Net::HTTP.start(SERVER,  8080) { |http|
        get = Net::HTTP::Get.new(path, {})
        http.request(get) { |response|
          expect(response.code).to eq('200')
        }
      }
    end
  end
end