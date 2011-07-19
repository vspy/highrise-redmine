class HighriseRedmine

  class Destination 

    def initialize(config, http) 
      @baseUrl = config.dstUrl
      @http = http
      @authToken = config.dstAuthToken
    end

    def deleteIssue(id)
      @http.delete( URI.parse(@baseUrl+"/issues/#{id}.xml"), @authToken, "X" )
    end

    def createIssue(subject, body)
      
      content = 
      @http.post( URI.parse(@baseUrl+"/issues.xml"), content, @authToken, "X" )
    end

  end

end


