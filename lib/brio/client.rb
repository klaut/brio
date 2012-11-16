require 'faraday_middleware'
#require 'json'
require 'brio/resources/post.rb'

module Brio

  class Client
    include API

    HTTP_VERBS = { create: 'post', delete: 'delete', get: 'get' }

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

    def method_missing(method_name, *args, &block)
      id = args[0] || 'me'
      case 
      when method_name.to_s =~ /(.*)_user(_?(.*))/
        users HTTP_VERBS[$1.to_sym], id, $3.gsub(/_/, '/')
      else
        super
      end 
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s =~ /(.*)_user(_?(.*))/
    end

    # POSTS
    def get_stream( global = false, count = 20 )
      scope = if global then 'global' else '' end
      r = @conn.get stream_url( scope ) ,  { :count => count, :include_deleted => 0 }
      Resources::Post.create_from_json r.body
    end

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


    private 
    def add_oauth_header
      @conn.authorization :bearer, config['token']
    end

    # USERS
    def users( verb, username='me', to_append='', body_hash='')
      username = "@#{username}" unless username == 'me'
      r = @conn.method(verb).call do |req|
        req.url "#{users_url username}/#{to_append}"
        req.body = body_hash
      end
      Resources::User.create_from_json r.body
    end

  end

end
