require 'highrise_redmine/highrise_parser'

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

          if (@storage.isProcessed('p',id))
            puts "* #{person[:lastName]} #{person[:firstName]}"
          else 
            if (companyId) 
              person[:company] = @storage.findCompany(companyId)
            end

            #TODO: really save it, update it, etc

            @storage.markAsProcessed('p', id)
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
