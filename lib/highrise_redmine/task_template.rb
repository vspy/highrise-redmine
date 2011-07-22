require 'mustache'

class HighriseRedmine

  class TaskTemplate < Mustache

    self.template_file = File.dirname(__FILE__) + '/task_template.mustache'

  end

end


