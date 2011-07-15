require 'yaml'

class HighriseRedmine

  class Config
    attr_accessor :srcUrl, :srcAuthToken, :dst
 
    def initialize(body)
      yaml = YAML.load( body )
      src = yaml['source'] || yaml['src'] || (raise "No source specified")
      @srcUrl = src['url'] || (raise "No source URL specified")
      @srcAuthToken = src['authToken'] || (raise "No source auth token specified")

      @dst = yaml['destination'] || yaml['dst'] || (raise "No destination url specified")
    end
  end

end
