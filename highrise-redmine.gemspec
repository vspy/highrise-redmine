$LOAD_PATH.unshift 'lib'

Gem::Specification.new do |s|
  s.name              = "highrise-redmine"
  s.version           = "0.0.1"
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "A tool to export Highrise contacts to Redmine"
  s.homepage          = "http://github.com/vspy/highrise-redmine"
  s.email             = "victorbilyk@gmail.com"
  s.authors           = [ "Victor Bilyk" ]
  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("test/**/*")
  s.executables       = %w( highrise-redmine )
  s.description       = <<desc
desc
  s.add_dependency('sqlite3', '>= 1.3.3')
  s.add_dependency('xml-simple', '>= 1.1.0')
  s.add_dependency('mustache', '>= 0.99.4')
end

