module Brio
  module Resources

    class Resource
      def initialize( attr_hash={} )
        attr_hash.map do |(k,v)|
          writer_m = "#{k}="
          public_send("#{k}=", v) if respond_to? writer_m
        end
      end

      def self.create_from_json( json )
        if json['data']
          if json['data'].kind_of? Array 
            json['data'].map{ |post| self.new post }.reverse
          else
            self.new json['data']
          end
        else
          NullResource.new json['meta']
        end
      end
    end

    class NullResource
      attr_reader :text

      def initialize( data )
        @text = "#{data['code']} - #{data['error_message']}"
      end
    end

  end
end