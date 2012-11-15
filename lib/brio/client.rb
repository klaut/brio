require 'faraday_middleware'
#require 'json'
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

    # POSTS
    def get_stream( global = false, count = 20 )
      scope = if global then 'global' else '' end
      r = @conn.get stream_url( scope ) ,  { :count => count, :include_deleted => 0 }
      Resources::Post.create_from_json r.body
    end

    # @client.post :create, text: "tralala"
    # @client.post :delete, id: '1'
    # @client.post :reply, to: '1', text: 'yo'
    # method: :create, :delete ....
    # options = {id:, text:}
    # def dpost( method, options )
    #   verb, id, body_hash = case method
    #                         when :create then [:post, nil, options]
    #                         when :reply then [:post, nil, {reply_to: options[:id], text: options[:text]}]
    #                         when :delete then [:delete, options[:id], nil]
    #                         else method
    #                         end
    #   r = @conn.method(verb).call do |req|
    #     req.url posts_url
    #     req.body = body_hash
    #   end
    #   Resources::Post.create_from_json r.body
    # end

    #body_hash: { text: message, [reply_to: post_id] }
    def post( body_hash )
      r = @conn.post do |req|
        req.url posts_url
        req.body = body_hash
      end
      Resources::Post.create_from_json r.body
    end

    def delete_post( id )
      r = @conn.delete do |req|
        req.url posts_url( id )
      end
      Resources::Post.create_from_json r.body
    end

    def repost( id )
      r = @conn.post do |req|
        req.url repost_url( id )
      end
      Resources::Post.create_from_json r.body
    end

    # USERS

    def user_info( id='me')
      r = @conn.get users_url(id)
      r.body
    end

    private 
    def add_oauth_header
      @conn.authorization :bearer, config['token']
    end

  end

end
