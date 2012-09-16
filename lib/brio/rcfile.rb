require 'singleton'

module Brio

  class RCFile
    include Singleton
    
    FILE_NAME = ".brio.rc" 

    def initialize
      @path = File.join( ENV['HOME'], FILE_NAME )
      @data = load_data
    end

    def []=(param, val)
      config[param] = val
      save_data
    end

    def [](param)
      config[param]
    end

    def config
      @data['config']
    end

    def empty?
      @data == default_config
    end


    private
    def default_config
      {'config' => {}}
    end

    def load_data
      require 'yaml'
      YAML.load_file(@path)
    rescue Errno::ENOENT
      default_config
    end

    def save_data
      require 'yaml'
      File.open(@path, File::RDWR|File::TRUNC|File::CREAT, 0600) do |rcfile|
        rcfile.write @data.to_yaml
      end
    end

  end

end