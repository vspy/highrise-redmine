require 'sqlite3'

class Storage 
  def initialize(dbFilename)
    @db = SQLite3::Database.new( dbFilename )
    @db.execute( "create table if not exists companies(id INTEGER PRIMARY KEY ASC, highrise_id text, name text)" )
    @db.execute( "create unique index if not exists c_hr_id on companies(highrise_id)" )

    @findCompanyQuery = @db.prepare("select name from companies where highrise_id=:highrise_id")
    @createCompanyQuery = @db.prepare("insert into companies (highrise_id, name) values (:highrise_id, :name)")
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
end
