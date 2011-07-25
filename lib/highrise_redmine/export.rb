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

      @attachmentsUrl = config.attachmentsUrl
      @projectId = config.projectId
      @trackerId = config.trackerId
      @priorityId = config.priorityId
      @statusId = config.statusId
    end 

    def run
      toDelete = @storage.recover
      if (toDelete.length > 0) 
        puts '... Removing incomplete issues from redmine'
        toDelete.each { |id| @dst.deleteIssue(id) }
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

      puts '... Updating users list'
      userData = @src.getUsers()
      userData.each { |user|
        id = user[:id]
        email = user[:email]
        @storage.addUser(id,email)
        puts "#{id} -> #{email}"
      }

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
            issueHash = {
              :subject => "#{person[:lastName]} #{person[:firstName]}",
              :body => body,
              :project_id => @projectId,
              :priority_id => @priorityId,
              :tracker_id => @trackerId,
              :status_id => @statusId,
#              :assigned_to_id => @mapper.map(),
            }

            redmineId = @dst.createIssue(issueHash)
            @storage.markTargetId(id, redmineId)

            updates = sortUpdates( loadNotesAndTasks(id) )

            updates.each { |u|
              template = (u[:type]==:note)?NoteTemplate.new : TaskTemplate.new
              template[:content] = u
              updateHash = issueHash.clone
              updateHash[:notes] = template.render
              @dst.updateIssue(redmineId, updateHash)
            }

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

    def sortUpdates(updates)
      updates.sort_by{ |c| "#{c[:created]}" }
    end

    def loadNotesAndTasks(id)
      updates = []

      ## read all notes
      notesOffset = 0
      begin
        notesData = @src.getNotes(id, notesOffset)

        notesData.each{ |note| 
          note[:type] = :note
          updates << note
        } 

        notesOffset += notesData.length
      end while notesData.length == @src.notesBatchSize
  
      ## tasks processing
      tasksOffset = 0
      begin
        tasksData = @src.getTasks(id, tasksOffset)

        tasksData.each{ |task|
          task[:type] = :task
          updates << task
        } 

        tasksOffset += tasksData.length
      end while tasksData.length == @src.tasksBatchSize

      updates
    end
    
  end

end
