class HighriseRedmine

  class UserMapper

    def initialize(cfg)
      @mapping = cfg.mapping 
      @defaultMapping = cfg.defaultMapping
    end

    def map(name)
      @mapping[name] || @defaultMapping
    end
    
  end

end

