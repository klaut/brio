module Brio
  module Format
    require 'time'
    require 'highline/import'

    class Pretty

      HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
        cs[:username]        = [ :magenta ]
        cs[:end_line]        = [ :green ]
        cs[:mention]        = [ :black, :on_white ]
      end

      def print_post( post )
        say "<%= color('@#{post.username}', :username) %>"
        say "#{post.text}"
        say "<%= color('id: #{post.id} (#{pretty_format_time(post.created_at)})', :end_line) %>"
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