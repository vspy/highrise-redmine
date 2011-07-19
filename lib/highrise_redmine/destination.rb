require 'highrise_redmine/redmine_template'

class HighriseRedmine

  class Destination 

    def initialize(config, http) 
      @baseUrl = config.dstUrl
      @http = http
      @authToken = config.dstAuthToken
    end

    def deleteIssue(id)
      @http.delete( URI.join(@baseUrl, "issues/#{id}.xml"), @authToken, "X" )
    end

    def createIssue(content)
      template = RedmineTemplate.new
      template[:content] = content
      @http.post( URI.join(@baseUrl, "issues.xml"), template.render, @authToken, "X" )
    end

  end

end


