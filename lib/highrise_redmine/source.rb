require 'uri'

class HighriseRedmine

  class Source ;
    attr_accessor :companiesBatchSize, :personsBatchSize, :notesBatchSize

    def initialize(config, http) 
      @baseUrl = config.srcUrl
      @http = http
      @authToken = config.srcAuthToken
      @companiesBatchSize = 500
      @personsBatchSize = 500
      @notesBatchSize = 25
    end

    def getCompanies(offset)
      body = @http.get( URI.join(@baseUrl, "companies.xml?n=#{offset}"), @authToken, "X" )
      HighriseRedmine::HighriseParser.parseCompanies(body)
    end

    def getPersons(offset)
      body = @http.get( URI.join(@baseUrl, "people.xml?n=#{offset}"), @authToken, "X" )
      HighriseRedmine::HighriseParser.parsePersons(body)
    end

    def getNotes(id, offset)
      body = @http.get( URI.join(@baseUrl, "people/#{id}/notes.xml?n=#{offset}"), @authToken, "X" )
      HighriseRedmine::HighriseParser.parseNotes(body)
    end

  end

end

