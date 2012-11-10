module Brio
  module Format
    require 'time'
    require 'highline/import'

    class Pretty

      HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
        cs[:username]        = [ :bold, :green ]
        cs[:end_line]        = [ :magenta ]
      end

      def print_post( post )
        say "<%= color('@#{post['user']['username']}', :username) %>"
        say "#{post['text']}"
        say "<%= color('#{post['id']} (#{pretty_format_time(post['created_at'])})', :end_line) %>"
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