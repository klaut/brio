module Brio

  module API

    CLIENT_ID = '9JnCd6aS5VGNjd7p5Cx6EA7qd6Xz7eEs'
    
    DEFAULT_OAUTH_HOST = 'alpha.app.net'
    DEFAULT_API_HOST = 'alpha-api.app.net'
    DEFAULT_PROTOCOL = 'https'

    REDIRECT_URI = 'https://brioapp.herokuapp.com/auth/callback/'
    SCOPE = 'stream,email,write_post,follow,messages,export'
    RESPONSE_TYPE = 'token'


    
    def oauth_url
      "#{protocol}://#{oauth_host}/oauth/authenticate?client_id=#{CLIENT_ID}&response_type=#{RESPONSE_TYPE}&scope=#{SCOPE}&redirect_uri=#{REDIRECT_URI}"
    end

    # POSTS

    def stream_url(scope="")
      "/stream/0/posts/stream/#{scope}"
    end

    def posts_url(id ="")
      "/stream/0/posts/#{id}"
    end

    def repost_url(id)
      "#{posts_url id}/repost"
    end

    def star_url(id)
      "#{posts_url id}/star"
    end

    def post_starred_by_url(id)
      "#{posts_url id}/stars"
    end

    def replies_url(id)
      "#{posts_url id}/replies"
    end

    # USERS

    def users_url( id = "me")
      # id can be also @username
      "/stream/0/users/#{id}"
    end

    def user_posts_url(id = 'me')
      "#{users_url id}/posts"
    end

    def user_stars_url(id = 'me')
      "#{users_url id}/stars"
    end

    def mentions_url(id = 'me')
      "#{users_url id}/mentions"
    end

    private
    def base_api_url
      "#{protocol}://#{api_host}"
    end

    def oauth_host
      DEFAULT_OAUTH_HOST
    end

    def api_host
      DEFAULT_API_HOST
    end

    def protocol
      DEFAULT_PROTOCOL
    end

  end

end