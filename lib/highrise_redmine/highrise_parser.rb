require 'xmlsimple'

class HighriseRedmine

  class HighriseParser 

    def self.parseCompanies(body) 
      companies = []

      doc = XmlSimple.xml_in(body)
      (doc['company']||[]).each do |company|
        companies << {
          :id =>  company['id'][0]['content'],
          :name => company['name'][0],
        }
      end

      return companies
    end

    def self.parseUsers(body)
      users = []

      doc = XmlSimple.xml_in(body)
      (doc['user']||[]).each do |user|
        users << {
          :id =>  user['id'][0]['content'],
          :email => user['email-address'][0],
        }
      end

      users
    end

    def self.parseNotes(body)
      notes = []

      doc = XmlSimple.xml_in(body)

      (doc['note']||[]).each do |note|
        notes<<{
          :created => DateTime.parse(note['created-at'][0]['content']),
          :body=>note['body'][0],
          :attachments=>(
            (note['attachments'] || []).map do |attachments|
              (attachments['attachment'] || []).map do |attachment|
                {:url=>attachment['url'][0],:name=>attachment['name'][0]}
            end end
          ).flatten
        } 
      end

      notes
    end

    def self.parseTasks(body)
      tasks = []

      doc = XmlSimple.xml_in(body)

      (doc['task']||[]).each do |task|
        tasks<<{
          :created => DateTime.parse(task['created-at'][0]['content']),
          :body=>task['body'][0],
          :due=>((task['due-at'] || []).map {|due| DateTime.parse(due['content'])})[0]
        } 
      end

      tasks
    end

    def self.parsePersons(body) 
      persons = []

      doc = XmlSimple.xml_in(body)

      (doc['person']||[]).each do |person|

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
          :authorId => person['author-id'][0]['content'],
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

