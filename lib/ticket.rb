require 'mustache'

class Ticket < Mustache

  self.path = File.dirname(__FILE__)

  def tagsNotEmpty
    return !(( self[:contact] || {}
             )[:tags] || []).empty?
  end

end
