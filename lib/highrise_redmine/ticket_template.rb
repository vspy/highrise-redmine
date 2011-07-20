require 'mustache'

class HighriseRedmine

  class TicketTemplate < Mustache

    self.template_file = File.dirname(__FILE__) + '/ticket_template.mustache'

    def tagsNotEmpty
      return !( self[:tags] || [] ).empty?
    end

  end

end
