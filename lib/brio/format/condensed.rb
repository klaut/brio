module Brio
  module Format
    require 'time'
    require 'highline/import'
    require 'brio/utils'

    class Condensed
      attr_accessor :wrap
      
      WRAP_SIZE = 80
      
      def initialize
        ::Brio::Utils.set_highline_colors
        set_wrap
      end

      def print_posts(posts)
        posts.each do |post|
          print_post post
        end
      end

      def print_post(post)
        top_line = []
        top_line << "At"
        top_line << ::Brio::Utils.colored_text(condensed_date(post.created_at), :time) + ","
        top_line << ::Brio::Utils.colored_text("@#{post.user.username}", :citation)
        top_line << "said: "
        say top_line.join(" ") << ::Brio::Utils.colored_text(post.normalized_text, :text)
      end

      def print_users(users)
        users.each do |user|
          print_user user
        end
      end

      def print_user(user)
        raw_output =  ""
        raw_output << "#{user.name} goes by @#{user.username}"
        raw_output << ", signed up at #{condensed_date(user.created_at)}"
        raw_output << ", is following #{user.counts.following} others"
        raw_output << ", and has #{user.counts.followers} followers."
        say raw_output
      end

      def set_wrap
        @wrap = [$terminal.output_cols, WRAP_SIZE].min
        $terminal.wrap_at = @wrap
      end

      private
      def condensed_date(timestr)
        Time.parse(timestr).strftime("%b %d, %H:%M:%S %Z")
      end
    end
  end
end
