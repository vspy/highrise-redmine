require 'yaml'

class HighriseRedmine

  class Config
    attr_accessor :src, :dst
 
    def initialize(filename)
      yaml = YAML.load_file( filename )
      @src = yaml['source'] || yaml['src'] || (raise "No source url specified")
      @dst = yaml['destination'] || yaml['dst'] || (raise "No destination url specified")
    end
  end

end
