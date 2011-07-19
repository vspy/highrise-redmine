class HighriseRedmine

  class UserMapper

    def initialize(cfg)
      @mapping = cfg.mapping 
      @defaultMapping = cfg.defaultMapping
    end

    def map(name)
      (@mapping?@mapping[name]:nil) || @defaultMapping
    end
    
  end

end

