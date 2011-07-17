require 'sqlite3'

class HighriseRedmine

  class Storage 
    def initialize(dbFilename)
      @db = SQLite3::Database.new( dbFilename )
      @db.execute( "create table if not exists companies(id INTEGER PRIMARY KEY ASC, highrise_id text, name text)" )
      @db.execute( "create unique index if not exists c_hr_id on companies(highrise_id)" )

      @db.execute( "create table if not exists processed(id INTEGER PRIMARY KEY ASC, highrise_id text, redmine_id text, finished integer)" )
      @db.execute( "create unique index if not exists p_hr_f_id on processed(highrise_id,finished)" )

      @findCompanyQuery = @db.prepare("select name from companies where highrise_id=:highrise_id")
      @createCompanyQuery = @db.prepare("insert into companies (highrise_id, name) values (:highrise_id, :name)")

      @markStartQuery = @db.prepare("insert into processed (highrise_id, redmine_id, finished) values (:highrise_id, null, 0)")
      @markTargetIdQuery = @db.prepare("update processed set redmine_id=:redmine_id where highrise_id=:highrise_id")
      @markProcessedQuery = @db.prepare("update processed set finished=1 where highrise_id=:highrise_id")

      @processedQuery = @db.prepare("select id from processed where highrise_id=:highrise_id and finished=1")

      @recoverQuery = @db.prepare("delete from processed where finished=0 and redmine_id is null")
      @toDeleteQuery = @db.prepare("select redmine_id from processed where redmine_id is not null")
      @onRecoverFinishedQuery = @db.prepare("delete from processed where finished=0 and redmine_id is not null")
    end

    def addCompany(id,name)
      findCompany(id) || (
        @createCompanyQuery.execute(:highrise_id=>id, :name=>name)
      )
    end

    def findCompany(id)
      @findCompanyQuery.execute!(:highrise_id => id) { |row| return row[0] }
      nil
    end

    def recover 
      @recoverQuery.execute
      @toDeleteQuery.execute.map { |row| row[0] } 
    end

    def onRecoverFinished
      @onRecoverFinishedQuery.execute
    end

    def markAsStarted(id)
      @markStartQuery.execute(:highrise_id=>id)
    end

    def markTargetId(id, redmine_id)
      @markTargetIdQuery.execute(:highrise_id=>id, :redmine_id=>redmine_id )
    end

    def markAsProcessed(id)
      @markProcessedQuery.execute(:highrise_id=>id)
    end

    def isProcessed(id)
      @processedQuery.execute!(:highrise_id => id) { |row| return true }
      false
    end

  end

end
