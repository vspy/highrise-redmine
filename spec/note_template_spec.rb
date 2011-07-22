# coding: utf-8
require 'highrise_redmine/note_template'

describe HighriseRedmine::NoteTemplate do

  it "formats note properly" do
    t = HighriseRedmine::NoteTemplate.new
    t[:created] = '2011-01-02 03:04:05'
    t[:body] = 'Hello, world!'
    t.render.should == 
<<-eos
Date: 2011-01-02 03:04:05

Hello, world!
eos
  end

end

