require 'faraday'
require 'json'

module Brio

  class Client
    include Brio::API

    def initialize
      @conn = Faraday.new(:url => base_api_url ) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
      @rc = Brio::RCFile.instance
      add_oauth_header unless @rc.empty?
    end

    def config
      @rc
    end

    def get_stream( global = false, count = 10 )
      if global
        r = @conn.get global_stream_url, { :count => count } 
      else 
        r = @conn.get user_stream_url ,  { :count => count } 
      end
      JSON.parse(r.body)
    end

    def post( text )
      r = @conn.post do |req|
        req.url posts_url
        req.headers['Content-Type'] = 'application/json'
        req.body = { text: "#{text}" }.to_json
      end
      JSON.parse(r.body)
    end

    private 
    def add_oauth_header
      @conn.authorization :bearer, @rc['token']
    end

  end

end