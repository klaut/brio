module Brio

  module API

    CLIENT_ID = '9JnCd6aS5VGNjd7p5Cx6EA7qd6Xz7eEs'
    
    DEFAULT_OAUTH_HOST = 'alpha.app.net'
    DEFAULT_API_HOST = 'alpha-api.app.net'
    DEFAULT_PROTOCOL = 'https'

    REDIRECT_URI = 'http://brioapp.herokuapp.com/auth/callback/'
    SCOPE = 'stream,email,write_post,follow,messages,export'
    RESPONSE_TYPE = 'token'


    
    def oauth_url
      "#{protocol}://#{oauth_host}/oauth/authenticate?client_id=#{CLIENT_ID}&response_type=#{RESPONSE_TYPE}&scope=#{SCOPE}&redirect_uri=#{REDIRECT_URI}"
    end

    def user_stream_url()
      stream_url
    end

    def global_stream_url
      stream_url 'global'
    end

    def stream_url(scope="")
      "/stream/0/posts/stream/#{scope}"
    end

    def posts_url(id ="")
      "/stream/0/posts/#{id}"
    end

    # id can be also @username
    def users_url( id = "me")
      "/stream/0/users/#{id}"
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