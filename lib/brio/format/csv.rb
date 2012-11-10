module Brio
  module Format
    require 'csv'
    require 'time'

    class CSV
      def format_stream( post )
        [post['id'], csv_formatted_time(post['created_at']), post['user']['username'], post['text']].to_csv
      end

      private
      # def csv_formatted_time(object, key=:created_at)
      #   return nil if object.nil?
      #   time = object.send(key.to_sym)
      #   time.utc.strftime("%Y-%m-%d %H:%M:%S %z")
      # end
      def csv_formatted_time( timestr )
        #time.utc.strftime("%Y-%m-%d %H:%M:%S %z")
        time = Time.parse timestr
        time.utc.strftime("%Y-%m-%d %H:%M:%S %z")
      end
    end

  end
end