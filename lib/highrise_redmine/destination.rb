require 'highrise_redmine/redmine_template'
require 'xmlsimple'

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
      response = @http.post( URI.join(@baseUrl, "issues.xml"), template.render, @authToken, "X" )
      doc = XmlSimple.xml_in(response)
      doc['id'][0]
    end

    def updateIssue(id, content)
      template = RedmineTemplate.new
      template[:content] = content
      @http.put( URI.join(@baseUrl, "issues/#{id}.xml"), template.render, @authToken, "X" )
    end

  end

end


