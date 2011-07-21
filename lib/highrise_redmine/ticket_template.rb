require 'mustache'

class HighriseRedmine

  class TicketTemplate < Mustache

    self.template_file = File.dirname(__FILE__) + '/ticket_template.mustache'

    def tagsNotEmpty
      return !( self[:tags] || [] ).empty?
    end

    def titleCompanyTags
      titleCompany || tagsNotEmpty
    end

    def titleCompany
      (self[:title]!=nil) || (self[:company]!=nil)
    end

  end

end
