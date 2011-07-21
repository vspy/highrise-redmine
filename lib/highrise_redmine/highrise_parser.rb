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

        tags = ((person['tags'] || []).map do |tags| (tags['tag']||[]).map do |tag|
          tag['name'][0]
        end end).flatten
        
        contactData = person['contact-data'] || []
        
        messengers = 
          (contactData.map do |cd| 
            (cd['instant-messengers'] || []).map do |ims|
              (ims['instant-messenger'] || []).map do |im|
                {:type => im['protocol'][0],
                  :address => normalize(im['address'][0]),
                  :location => normalize(im['location'][0])
                }
          end end end).flatten

        emails = 
          (contactData.map do |cd| 
            (cd['email-addresses'] || []).map do |emails|
              (emails['email-address'] || []).map do |email|
                {:location => normalize(email['location'][0]),
                  :address => normalize(email['address'][0])
                }
          end end end).flatten

        phones = 
          (contactData.map do |cd| 
            (cd['phone-numbers'] || []).map do |phones|
              (phones['phone-number'] || []).map do |phone|
                {:location => normalize(phone['location'][0]),
                  :number => normalize(phone['number'][0])
                }
          end end end).flatten
        
        persons << {
          :id => person['id'][0]['content'],
          :created => DateTime.parse(person['created-at'][0]['content']),
          :firstName => person['first-name'][0],
          :lastName => person['last-name'][0],
          :title => normalize(person['title'][0]),
          :companyId => person['company-id'][0]['content'],
          :tags => tags,
          :background => normalize(person['background'][0]),
          :messengers => messengers,
          :emails => emails,
          :phones => phones
        }
      end
    
      return persons
    end

    def self.normalize(s)
      (s == [] || s == {})? nil : s
    end

  end

end

