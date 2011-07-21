require 'uri'

class HighriseRedmine

  class Source ;
    attr_accessor :companiesBatchSize, :personsBatchSize, :notesBatchSize, :tasksBatchSize

    def initialize(config, http) 
      @baseUrl = config.srcUrl
      @http = http
      @authToken = config.srcAuthToken
      @companiesBatchSize = 500
      @personsBatchSize = 500
      @notesBatchSize = 25
      @tasksBatchSize = 25
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

    def getTasks(id, offset)
      body = @http.get( URI.join(@baseUrl, "people/#{id}/tasks.xml?n=#{offset}"), @authToken, "X" )
      HighriseRedmine::HighriseParser.parseTasks(body)
    end

  end

end

