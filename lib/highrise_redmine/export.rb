require 'highrise_redmine/highrise_parser'
require 'highrise_redmine/ticket_template'
require 'highrise_redmine/note_template'
require 'highrise_redmine/task_template'

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
      end while data.length == @src.companiesBatchSize

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
            template[:emails] = person[:emails]
            template[:phones] = person[:phones]
            template[:messengers] = person[:messengers]
            template[:background] = person[:background]
            template[:created] = person[:created].strftime("%a %b %d %H:%M:%S %z %Y")

            body = template.render

            redmineId = @dst.createIssue({
              :subject => "#{person[:lastName]} #{person[:firstName]}",
              :body => body,
              :project_id => @projectId,
              :priority_id => @priorityId,
              :tracker_id => @trackerId,
              :status_id => @statusId,
            ## TODO: assigned to id
            })
            @storage.markTargetId(id, redmineId)

            ## notes processing
            notesOffset = 0
            begin
              notesData = @src.getNotes(id, notesOffset)

              notesData.each{ |note|
                noteTemplate = NoteTemplate.new
                noteTemplate[:created] = note[:created]
                noteTemplate[:body] = note[:body]

                @dst.updateIssue(redmineId, {
                  :subject => "#{person[:lastName]} #{person[:firstName]}",
                  :body => body,
                  :project_id => @projectId,
                  :priority_id => @priorityId,
                  :tracker_id => @trackerId,
                  :status_id => @statusId,
                  :notes => noteTemplate.render
                })
              } 

              notesOffset += notesData.length
            end while notesData.length == @src.notesBatchSize
  
            ## tasks processing
            tasksOffset = 0
            begin
              tasksData = @src.getTasks(id, tasksOffset)

              tasksData.each{ |task|
                ## TODO: really update redmine issue
              } 

              tasksOffset += notesData.length
            end while tasksData.length == @src.tasksBatchSize
  
            @storage.markAsProcessed(id)
            puts "+ #{person[:lastName]} #{person[:firstName]}"
            count+=1
          end
        }

        offset += data.length
      end while data.length == @src.personsBatchSize

      puts 'Done.' 
      puts "Successfully exported #{count} contacts"
    end
    
  end

end
