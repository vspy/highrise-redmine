require 'mustache'

class HighriseRedmine

  class NoteTemplate < Mustache

    self.template_file = File.dirname(__FILE__) + '/note_template.mustache'


    def attachmentsNotEmpty
      !((self[:content] || {})[:attachmentUrls] || []).empty?
    end

  end

end

