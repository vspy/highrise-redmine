require 'uri'

class HighriseRedmine

  class Source 
    attr_accessor :batchSize

    def initialize(baseUrl, http) 
      @baseUrl = baseUrl
      @http = http
      @batchSize = 500
    end

    def getCompanies(offset)
      body = @http.get( URI.parse(@baseUrl+"/companies.xml?n=#{offset}") )
      HighriseRedmine::HighriseParser.parseCompanies(body)
    end

    def getPersons(offset)
      body = @http.get( URI.parse(@baseUrl+"/people.xml?n=#{offset}") )
      HighriseRedmine::HighriseParser.parsePersons(body)
    end

  end

end

