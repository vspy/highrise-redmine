require 'highrise_redmine/highrise_parser'
require 'highrise_redmine/ticket_template'

class HighriseRedmine

  class Export
 
    def initialize(config, src, storage, mapper, dst)
      @src = src
      @storage = storage
      @mapper = mapper
      @dst = dst

      @projectId = config.projectId
      @trackerId = config.trackerId
      @priorityId = config.priorityId
      @statusId = config.statusId
    end 

    def run

      toDelete = @storage.recover
      if (toDelete.length > 0) 
        puts '... Removing incomplete issues from redmine'

        toDelete.each { |id|
          @dst.deleteIssue(id)
        }
        @storage.onRecoverFinished
      end

      puts '... Updating companies list'
      offset = 0

      begin 
        data = @src.getCompanies(offset)

        data.each { |company|
          id = company[:id]
          name = company[:name]
          @storage.addCompany(id,name)
          puts "#{id} -> #{name}"
        }
 
        offset += data.length
      end while data.length == @src.batchSize

      puts '... Exporting contacts'
      count = 0
      offset = 0

      begin 
        data = @src.getPersons(offset)

        data.each { |person|
          id = person[:id]
          companyId = person[:companyId]

          if (@storage.isProcessed(id))
            puts "* #{person[:lastName]} #{person[:firstName]}"
          else 
            @storage.markAsStarted(id)
            if (companyId) 
              person[:company] = @storage.findCompany(companyId)
            end

            template = TicketTemplate.new
            template[:title] = person[:title]
            template[:company] = person[:company]
            template[:tags] = (person[:tags] || []).map { |t, i| {:first=> (i==0), :value=>t} }
            template[:background] = person[:background]

            puts("title: #{person[:title]}")
            puts("background: #{person[:background]}")

            body = template.render

            redmineId = @dst.createIssue({
              :subject => "#{person[:lastName]} #{person[:firstName]}",
              :body => body,
              :project_id => @projectId,
              :priority_id => @priorityId,
              :tracker_id => @trackerId,
              :status_id => @statusId
            ## TODO: assigned to id
            })
            puts "created: #{redmineId}"
            #TODO: really save it, update it, etc
            #
            #@storage.markTargetId(id, redmineId)

            @storage.markAsProcessed(id)
            puts "+ #{person[:lastName]} #{person[:firstName]}"
            count+=1
          end
        }

        offset += data.length
      end while data.length == @src.batchSize

      puts 'Done.' 
      puts "Successfully exported #{count} contacts"
    end
    
  end

end
