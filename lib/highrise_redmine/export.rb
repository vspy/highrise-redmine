class HighriseRedmine

  class Export
 
    def initialize(src, storage, dst)
      @src = src
      @storage = storage
      @dst = dst
    end 

    def run
      puts '... Updating companies list'
      offset = 0

      begin 
        data = @src.getCompanies(offset)

        data.each { |company|
          id = company[:id]
          name = company[:name]
          @storage.addCompany(id,name)
          puts "#{id}->#{name}"
        }
 
        offset += data.length
      end while data.length == @src.batchSize

      puts '... Exporting contacts'
      count = 0
      offset = 0

      begin 
        data = @src.getContacts(offset)

#        data.each { |contact|
#          #TODO: really save it, update it, etc
#          puts "#{contact[:lastName]} #{contact[:firstName]}"
#          count ++
#        }
#        
        offset += data.length
      end while data.length == @src.batchSize

      puts 'Done.' 
      puts "Successfully exported #{count} contacts"
    end
    
  end

end
