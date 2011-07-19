require 'uri'

class HighriseRedmine

  class Source 
    attr_accessor :batchSize

    def initialize(config, http) 
      @baseUrl = config.srcUrl
      @http = http
      @authToken = config.srcAuthToken
      @batchSize = 500
    end

    def getCompanies(offset)
      body = @http.get( URI.join(@baseUrl, "companies.xml?n=#{offset}"), @authToken, "X" )
      HighriseRedmine::HighriseParser.parseCompanies(body)
    end

    def getPersons(offset)
      body = @http.get( URI.join(@baseUrl, "people.xml?n=#{offset}"), @authToken, "X" )
      HighriseRedmine::HighriseParser.parsePersons(body)
    end

  end

end

