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
        say "<%= color(\"#{post.user.username}\", :username) %>"
        if post.text
          say "." * 80
          say "#{post.text.strip}"
          say "." * 80
        end
        say "<%= color('<id: #{post.id}#{reply_status post}> <#{pretty_format_time(post.created_at)}> <replies #{post.num_replies}>', :end_line) %>"
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
          say "." * 80
          say "#{user.description.text.strip}"
          say "." * 80
        end
        say "<%= color('<followers: #{user.counts.followers}, following: #{user.counts.following}> #{connection_stats user}', :end_line) %>"
        say "\n"
      end

      def set_wrap
        $terminal.wrap_at = 80
      end

      def connection_stats( user )
        "<follows you: #{truth_to_tick_char user.follows_you}, you follow: #{truth_to_tick_char user.you_follow}>"
      end

      def reply_status( post )
        if post.reply_to
          " | in reply to: #{post.reply_to}"
        end
      end

      private
      def pretty_format_time( timestr )
        time = Time.parse( timestr ).utc.getlocal
        time.strftime("%b %e %H:%M")
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
