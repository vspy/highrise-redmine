class HighriseRedmine

  class TokenProvider

    def initialize(cfg)
      @mapping = cfg.mapping 
      @defaultToken = cfg.defaultToken
    end

    def getToken(name)
      (@mapping?@mapping[name]:nil) || @defaultToken
    end
    
  end

end

