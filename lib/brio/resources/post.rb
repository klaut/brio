module Brio
  module Resources
    class Post < Resource
      attr_accessor :id, :user, :created_at, :text, :num_replies, :num_stars, :num_reposts, :reply_to, :repost_of

      def normalized_text
        text.gsub(/\r\n/, "\n").gsub(/\n\n/, "\n").gsub(/\n/, " ").strip
      end
    end
  end
end
