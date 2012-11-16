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
      case 
      when method_name.to_s =~ /(.*)_user(_?(.*))/
        id = args[0] || 'me'
        users HTTP_VERBS[$1.to_sym], id, $3.gsub(/_/, '/')
      when method_name.to_s =~ /(.*)_post(_?(.*))/
        posts HTTP_VERBS[$1.to_sym], args, $3.gsub(/_/, '/')
      else
        super
      end 
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s =~ /(.*)_user(_?(.*))/ ||
      method_name.to_s =~ /(.*)_post(_?(.*))/
    end


    private 
    def add_oauth_header
      @conn.authorization :bearer, config['token']
    end

    # USERS
    def users( verb, username='me', to_append='')
      username = "@#{username}" unless username == 'me'
      r = @conn.method(verb).call do |req|
        req.url "#{users_url username}/#{to_append}"
      end
      case to_append
      when 'mentions', 'stars', 'posts'
        Resources::Post.create_from_json r.body
      else
        Resources::User.create_from_json r.body
      end
    end

    #POSTS
    def posts( verb, args, to_append='')
      id = if args.first && args.first.is_a?(String) then args.first else "" end
      params_hash = if args.last && args.last.is_a?(Hash) then args.last else {} end
      r = @conn.method(verb).call do |req|
        req.url "#{posts_url id}/#{to_append}"
        if verb.to_s == 'get'
          req.params = params_hash
        else
          req.body = params_hash
        end
      end
      case to_append
      when 'reposters', 'stars'
        Resources::User.create_from_json r.body
      else
        Resources::Post.create_from_json r.body
      end
    end

  end

end
