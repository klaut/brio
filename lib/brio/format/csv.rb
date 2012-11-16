module Brio
  module Format
    require 'csv'
    require 'time'
    require 'highline/import'

    class CSV
      POST_HEADER = ["id", "timestampt", "username", "text"]
      USER_HEADER = ["username", "name", "description", "followers", "following", "follows you", "you follow"]

      def print_posts( posts )
        say POST_HEADER.to_csv
        posts.each do |post|
          print_post post
        end
      end

      def print_post( post )
        say [post.id, csv_formatted_time(post.created_at), post.user.username, post.text].to_csv
      end

      private
      def csv_formatted_time( timestr )
        Time.parse( timestr ).utc.strftime("%Y-%m-%d %H:%M:%S %z")
      end
    end

  end
end
