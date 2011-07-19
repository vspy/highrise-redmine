require 'mustache'

class HighriseRedmine

  class RedmineTemplate < Mustache

    self.template_file = File.dirname(__FILE__) + '/redmine_template.mustache'

  end

end
