require 'yaml'

class HighriseRedmine

  class Config
    attr_accessor :srcUrl, :srcAuthToken, :dstUrl,
                  :dstAuthToken, :projectId, :statusId,
                  :priorityId, :trackerId, :mapping, :defaultMapping,
                  :attachmentsUrl
 
    def initialize(body)
      yaml = YAML.load( body )
      src = yaml['source'] || yaml['src'] || (raise "No source specified")
      @srcUrl = src['url'] || (raise "No source URL specified")
      @srcAuthToken = src['authToken'] || (raise "No source auth token specified")

      dst = yaml['destination'] || yaml['dst'] || (raise "No destination specified")
      @dstUrl = dst['url'] || (raise "No destination URL specified")
      @dstAuthToken = dst['authToken'] || (raise "No destination auth token specified")

      @projectId =  dst['project'] || dst['project_id'] || (raise "project_id is not specified")
      @trackerId =  dst['tracker'] || dst['tracker_id'] || (raise "tracker_id is not specified")
      @priorityId =  dst['priority'] || dst['priority_id'] || (raise "priority_id is not specified")
      @statusId =  dst['status'] || dst['status_id'] || (raise "status_id is not specified")
      @attachmentsUrl = dst['attachments_url'] || (raise "attachments_url is not specified")

      @mapping = dst['mapping']
      @defaultMapping = dst['default_mapping']
    end
  end

end
