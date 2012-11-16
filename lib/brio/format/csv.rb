module Brio
  module Format
    require 'csv'
    require 'time'
    require 'highline/import'

    class CSV
      POST_HEADER = ["id", "timestampt", "username", "text", "replies"]
      USER_HEADER = ["username", "name", "joined", "followers", "following"]

      def print_posts( posts )
        say POST_HEADER.to_csv
        posts.each do |post|
          print_post post
        end
      end

      def print_post( post )
        say [post.id, csv_formatted_time(post.created_at), post.user.username, post.text, post.num_replies].to_csv
      end

      def print_users( users )
        say USER_HEADER.to_csv
        users.each do |u|
          print_user u
        end
      end

      def print_user( user )
        say [user.username, user.name, csv_formatted_time(user.created_at), user.counts.followers, user.counts.following].to_csv
      end

      def set_wrap
        $terminal.wrap_at = :auto
      end

      private
      def csv_formatted_time( timestr )
        Time.parse( timestr ).utc.strftime("%Y-%m-%d %H:%M:%S %z")
      end
    end

  end
end
