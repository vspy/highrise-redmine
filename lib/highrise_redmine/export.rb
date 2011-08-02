# coding: utf-8
require 'highrise_redmine/highrise_parser'
require 'highrise_redmine/ticket_template'
require 'highrise_redmine/note_template'
require 'highrise_redmine/task_template'

class HighriseRedmine

  class Export

    TIME_FORMAT = "%a %b %d %H:%M:%S %z %Y"
 
    def initialize(config, src, storage, dst)
      @src = src
      @storage = storage
      @dst = dst

      @attachmentsDir = config.attachmentsDir ? File.expand_path(config.attachmentsDir) : (Dir.pwd + File::Separator + "attachments")
      @attachmentsUrl = config.attachmentsUrl
      @assignedTo = config.assignedTo
      @projectId = config.projectId
      @trackerId = config.trackerId
      @priorityId = config.priorityId
      @statusId = config.statusId
      @customFields = (config.customFields || {})
      @urlFieldId = config.urlFieldId
    end 

    def formatDates(hash)
      result = {}
      hash.each {|k,v|
        if (DateTime === v)
          result[k] = v.strftime(TIME_FORMAT) 
        else 
          result[k] = v
        end
      }
      result
    end

    def createAttachmentsDir
      if File.directory?(@attachmentsDir)
        return
      end
      Dir.mkdir(@attachmentsDir)
    end

    def findUnusedFile(filename)
      current = filename
      
      while (File.exist?(@attachmentsDir+File::Separator+current))
        extension = File.extname(current)
        basename = File.basename(current, extension)
        dirname = File.dirname(current)

        idx = basename.index(/-\d+$/)
        if idx
          n = (basename[idx+1, (basename.length-idx-1)]).to_i
          current = dirname + File::Separator + basename[0,idx] + "-#{n+1}" + extension
        else
          current = dirname + File::Separator + basename+"-2" + extension
        end
      end

      @attachmentsDir+File::Separator+current
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

      puts '... Retreiving completed tasks'
      tasks = @src.getCompletedTasks
      puts "got #{tasks.length} completed tasks"

      tasksBySubject = {}
      tasks.each {|task|
        subjectId = task[:subjectId]
        if (subjectId)
          task[:type] = :task
          list = tasksBySubject[subjectId] || ( tasksBySubject[subjectId] = [] )
          list << task
        end
      }
      
      puts '... Exporting contacts'
      count = 0
      offset = 0
      firstAttachment = true

      begin 
        data = @src.getPersons(offset)

        data.each { |person|
          id = person[:id]
          companyId = person[:companyId]
          authorId = person[:authorId]

          if (@storage.isProcessed(id))
            puts "* #{person[:lastName]} #{person[:firstName]}"
          else 
            @storage.markAsStarted(id)
            puts "+ #{person[:lastName]} #{person[:firstName]}"

            if (companyId) 
              person[:company] = @storage.findCompany(companyId)
            end
            if (authorId) 
              person[:owner] = @storage.findUser(authorId)
            end

            customFields = @customFields.clone
            if (@urlFieldId) 
              customFields[@urlFieldId] = @src.humanUrlFor(id)
            end 

            template = TicketTemplate.new
            template[:title] = person[:title]
            template[:company] = person[:company]
            template[:tags] = (person[:tags] || []).each_with_index.map { |t, i| {:first=> (i==0), :value=>t} }
            template[:emails] = person[:emails]
            template[:phones] = person[:phones]
            template[:messengers] = person[:messengers]
            template[:background] = person[:background]
            template[:created] = person[:created].strftime(TIME_FORMAT)

            body = template.render
            issueHash = {
              :subject => "#{person[:lastName]} #{person[:firstName]}",
              :body => body,
              :project_id => @projectId,
              :priority_id => @priorityId,
              :tracker_id => @trackerId,
              :status_id => @statusId,
              :owner => person[:owner],
              :assigned_to_id => @assignedTo,
              :custom_fields => customFields.map {|k,v| {:id=>k,:value=>v} }
            }

            redmineId = @dst.createIssue(issueHash)
            @storage.markTargetId(id, redmineId)


            notesAndTasks = loadNotesAndTasks(id)
            notesAndTasks.concat( tasksBySubject[id] || [] )
            updates = sortUpdates( notesAndTasks )

            notesWithFiles = updates.find_all { |u| u[:type]==:note && u[:attachments] && !u[:attachments].empty? }
            if (!notesWithFiles.empty? && firstAttachment)
              createAttachmentsDir
            end

            notesWithFiles.each { |note| 
              result = []
              note[:attachments].each { |attachment|
                file = findUnusedFile(attachment[:name])
                @src.download(attachment[:url], file)
                result << File.basename(file)
              }
              note[:attachmentUrls] = result.map { |f| URI.join(@attachmentsUrl, URI.escape(f)) }
            }

            updates.each { |u|
              template = (u[:type]==:note)?NoteTemplate.new : TaskTemplate.new
              template[:content] = formatDates(u)

              updateHash = issueHash.clone
              updateHash[:notes] = template.render
              @dst.updateIssue(redmineId, updateHash)
            }

            @storage.markAsProcessed(id)
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
