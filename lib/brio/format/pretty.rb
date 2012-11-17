 module Brio
  module Format
    require 'time'
    require 'highline/import'

    class Pretty
      attr_accessor :wrap

      HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
        cs[:username]        = [ :red ]
        cs[:end_line]        = [ :yellow] #:rgb_aaaaaa
        cs[:mention]        = [ :black, :on_white ]
      end

      def initialize
        set_wrap
      end


      def print_posts( posts )
        posts.each do |post|  
          print_post post
        end
      end

      def print_post( post )
        say "<%= color(\"#{post.user.username}\", :username) %>"
        if post.text
          say "." * @wrap
          say "#{post.text.strip}"
          say "." * @wrap
        end
        say "<%= color('<id: #{post.id} | #{pretty_format_time(post.created_at)}#{reply_status post}> <replies #{post.num_replies}>', :end_line) %>"
        say "\n"
      end

      def print_users( users )
        users.each do |u|
          print_user u
        end
      end

      def print_user( user )
        say "\n"
        say "<%= color(\"#{user.name}\", :username) %> [#{user.username}]"
        if user.description.has_key? 'text'
          say "." * @wrap
          say "#{user.description.text.strip}"
          say "." * @wrap
        end
        say "<%= color('<followers: #{user.counts.followers} | following: #{user.counts.following} | since: #{pretty_format_time(user.created_at, %{%b %e %Y})}> #{connection_stats user}', :end_line) %>"
        say "\n"
      end

      def set_wrap
        if $terminal.output_cols < 100
          @wrap = $terminal.output_cols
        else
          @wrap = 100
        end
        $terminal.wrap_at = @wrap
      end

      def connection_stats( user )
        "<follows you: #{truth_to_tick_char user.follows_you} | you follow: #{truth_to_tick_char user.you_follow}>"
      end

      def reply_status( post )
        if post.reply_to
          " | in reply to: #{post.reply_to}"
        end
      end

      private
      def pretty_format_time( timestr, format = "%b %e %H:%M" )
        time = Time.parse( timestr ).utc.getlocal
        time.strftime(format)
      end

      def truth_to_tick_char( truth_str )
        if truth_str
          "\u2714"
        else
          "\u2717"
        end
      end

    end

  end
end
