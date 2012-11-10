module Brio
  module Format
    require 'csv'
    require 'time'
    require 'highline/import'

    class CSV
      def print_post( post )
        say [post.id, csv_formatted_time(post.created_at), post.username, post.text].to_csv
      end

      private
      # def csv_formatted_time(object, key=:created_at)
      #   return nil if object.nil?
      #   time = object.send(key.to_sym)
      #   time.utc.strftime("%Y-%m-%d %H:%M:%S %z")
      # end
      def csv_formatted_time( timestr )
        Time.parse( timestr ).utc.strftime("%Y-%m-%d %H:%M:%S %z")
      end
    end

  end
end