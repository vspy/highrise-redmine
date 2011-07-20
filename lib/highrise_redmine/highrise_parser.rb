require 'xmlsimple'

class HighriseRedmine

  class HighriseParser 

    def self.parseCompanies(body) 
      companies = []

      doc = XmlSimple.xml_in(body)
      doc['company'].each do |company|
        companies << {
          :id =>  company['id'][0]['content'],
          :name => company['name'][0],
        }
      end

      return companies
    end

    def self.parsePersons(body) 
      persons = []

      doc = XmlSimple.xml_in(body)

      doc['person'].each do |person|
        tags = ((person['tags'] || [{"tag"=>[]}])[0]["tag"] || []).map{|t| t['name'][0] }

        persons << {
          :id => person['id'][0]['content'],
          :firstName => person['first-name'][0],
          :lastName => person['last-name'][0],
          :title => person['title'][0],
          :companyId => person['company-id'][0]['content'],
          :tags => tags
        }
      end
    
      return persons
    end

  end

end

