class HighriseRedmine

  class Destination 

    def initialize(baseUrl, http, authToken) 
      @baseUrl = baseUrl
      @http = http
      @authToken = authToken
    end

    def deleteIssue(id)
      @http.delete( URI.parse(@baseUrl+"/issues/#{id}.xml"), @authToken, "X" )
    end

    def createIssue(subject, body)
      @http.post( URI.parse(@baseUrl+"/issues.xml"), @authToken, "X" )
    end

  end

end


