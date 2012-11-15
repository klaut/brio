module Brio
  module Format
    require 'time'
    require 'highline/import'

    class Pretty

      HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
        cs[:username]        = [ :red ]
        cs[:end_line]        = [ :yellow] #:rgb_aaaaaa
        cs[:mention]        = [ :black, :on_white ]
      end

      def print_posts( posts )
        posts.each do |post|  
          print_post post
        end
      end

      def print_post( post )
        say "<%= color('@#{post.user.username}', :username) %>"
        say "#{post.text}"
        say "<%= color('<id: #{post.id}> <#{pretty_format_time(post.created_at)}>', :end_line) %>"
        say "\n"
      end


      private
      def pretty_format_time( timestr )
        time = Time.parse( timestr ).utc.getlocal
        time.strftime("%b %e %H:%M")
      end

    end

  end
end
