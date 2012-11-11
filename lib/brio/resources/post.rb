module Brio
  module Resources

    class Post

      attr_reader :id, :username, :created_at, :text

      def self.create_from_json( json )
        if json['data']
          Post.new json['data']
        else
          NullPost.new json['meta']
        end
      end

      def self.create_many_from_json ( json )     
        posts = json['data'].map{ |post| Post.new post }.reverse
      end

      def initialize( data )
        @id = data['id']
        @username = data['user']['username']
        @created_at = data['created_at']
        @text = (data['text'] || '').strip
      end

    end


    class NullPost
      attr_reader :text

      def initialize( data )
        @text = "#{data['code']} - #{data['error_message']}"
      end
    end

  end
end