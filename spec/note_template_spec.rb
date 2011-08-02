# coding: utf-8
require 'highrise_redmine/note_template'

describe HighriseRedmine::NoteTemplate do

  it "formats note properly" do
    t = HighriseRedmine::NoteTemplate.new
    t[:content] = {
      :created => '2011-01-02 03:04:05',
      :body => 'Hello, world!',
      :attachmentUrls => (['пример.pdf', 'sample.pdf'].map { |f| URI.join('http://example.org/files/', URI.escape(f)) })
    }
    t.render.should == 
<<-eos
Date: 2011-01-02 03:04:05

Hello, world!

Вложения:
http://example.org/files/%D0%BF%D1%80%D0%B8%D0%BC%D0%B5%D1%80.pdf
http://example.org/files/sample.pdf
eos
  end

  it "formats note without attachments" do
    t = HighriseRedmine::NoteTemplate.new
    t[:content] = {
      :created => '2011-01-02 03:04:05',
      :body => 'Hello, world!',
    }
    t.render.should == 
<<-eos
Date: 2011-01-02 03:04:05

Hello, world!
eos
  end

end

