require 'faraday_middleware'
require 'json'
require 'brio/resources/post.rb'

module Brio

  class Client
    include API

    def initialize
      @conn = Faraday.new(:url => base_api_url ) do |faraday|
        faraday.request  :json #:url_encoded
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter  Faraday.default_adapter
      end
      @rc = RCFile.instance
      add_oauth_header unless @rc.empty?
    end

    def config
      @rc
    end

    def get_stream( global = false, count = 20 )
      scope = if global then 'global' else '' end
      r = @conn.get stream_url( scope ) ,  { :count => count }
      Resources::Post.create_many_from_json r.body
    end

    def post( text )
      r = @conn.post do |req|
        req.url posts_url
        req.headers['Content-Type'] = 'application/json'
        req.body = { text: "#{text}" }.to_json
      end
      Resources::Post.create_from_json r.body
    end

    private 
    def add_oauth_header
      @conn.authorization :bearer, config['token']
    end

  end

end