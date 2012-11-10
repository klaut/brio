module Brio
  module Format
    require 'time'

    class Pretty

      def format_stream( post )
        # "#{post['id']} :: #{post['user']['username']} :: #{post['text']} :: [ #{post['created_at']} ]"
        # printf("%2d - %s\n",index,task.name) printf(" %-10s %s\n","Created:",task.created_date)
        sprintf("%s (%s)\n %-8s - %s\n\n", post['user']['username'], pretty_format_time(post['created_at']), post['id'], post['text'])
      end


      private
      def pretty_format_time( timestr )
        time = Time.parse( timestr ).utc.getlocal
        time.strftime("%b %e %H:%M")
      end

    end

  end
end