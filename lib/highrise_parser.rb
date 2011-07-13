require 'xmlsimple'

class HighriseParser 

  def parse(body) 
    persons = []

    doc = XmlSimple.xml_in(body)
    doc['person'].each do |person|
    end
    
    return persons
  end

end

