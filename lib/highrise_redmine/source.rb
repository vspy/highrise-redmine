require 'uri'

class HighriseRedmine

  class Source 
    attr_accessor :batchSize

    def initialize(baseUrl, http, authToken) 
      @baseUrl = baseUrl
      @http = http
      @authToken = authToken
      @batchSize = 500
    end

    def getCompanies(offset)
      body = @http.get( URI.parse(@baseUrl+"/companies.xml?n=#{offset}"), @authToken, "X" )
      HighriseRedmine::HighriseParser.parseCompanies(body)
    end

    def getPersons(offset)
      body = @http.get( URI.parse(@baseUrl+"/people.xml?n=#{offset}"), @authToken, "X" )
      HighriseRedmine::HighriseParser.parsePersons(body)
    end

  end

end

