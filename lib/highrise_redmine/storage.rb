require 'sqlite3'

class HighriseRedmine

  class Storage 
    def initialize(dbFilename)
      @db = SQLite3::Database.new( dbFilename )
      @db.execute( "create table if not exists companies(id INTEGER PRIMARY KEY ASC, highrise_id text, name text)" )
      @db.execute( "create unique index if not exists c_hr_id on companies(highrise_id)" )

      @db.execute( "create table if not exists processed(id INTEGER PRIMARY KEY ASC, type text, highrise_id text)" )
      @db.execute( "create unique index if not exists p_t_hr_id on processed(type,highrise_id)" )

      @findCompanyQuery = @db.prepare("select name from companies where highrise_id=:highrise_id")
      @createCompanyQuery = @db.prepare("insert into companies (highrise_id, name) values (:highrise_id, :name)")
      @markQuery = @db.prepare("insert into processed (type, highrise_id) values (:type, :highrise_id)")
      @processedQuery = @db.prepare("select id from processed where type=:type and highrise_id=:highrise_id")
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

    def markAsProcessed(type, id)
      @markQuery.execute(:type=>type, :highrise_id=>id)
    end

    def isProcessed(type, id)
      @processedQuery.execute!(:type => type, :highrise_id => id) { |row| return true }
      false
    end

  end

end
