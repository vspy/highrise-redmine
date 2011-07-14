require 'yaml'

class HighriseRedmine

  class Config
    def initialize(filename)
      @yaml = YAML.load_file( filename )

      raise "No source url specified" if @yaml[:source].nil?
    end
  end

end
