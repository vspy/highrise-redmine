require 'yaml'

class HighriseRedmine

  class Config
    attr_accessor :src, :dst
 
    def initialize(body)
      yaml = YAML.load( body )
      @src = yaml['source'] || yaml['src'] || (raise "No source url specified")
      @dst = yaml['destination'] || yaml['dst'] || (raise "No destination url specified")
    end
  end

end
