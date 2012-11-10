module Brio
  module Resources

    class Post

      attr_reader :id, :username, :created_at, :text

      def self.create_from_json( json )
        Post.new json['data']
      end

      def self.create_many_from_json ( json )     
        posts = json['data'].map{ |post| Post.new post }.reverse
      end

      def initialize( data )
        @id = data['id']
        @username = data['user']['username']
        @created_at = data['created_at']
        @text = data['text'].strip
      end

    end

  end
end