# coding: utf-8
require 'highrise_redmine/note_template'

describe HighriseRedmine::TaskTemplate do

  it "formats task properly" do
    t = HighriseRedmine::TaskTemplate.new
    t[:created] = '2011-01-02 03:04:05'
    t[:body] = 'Hello, world!'
    t[:due] = '2012-02-03 04:05:06'
    t[:assignee] = 'bob'
    t.render.should == 
<<-eos
Date: 2011-01-02 03:04:05

Задача: Hello, world!
Исполнить до: 2012-02-03 04:05:06
Назначенное лицо: bob
eos
  end

  it "formats incomplete task properly" do
    t = HighriseRedmine::TaskTemplate.new
    t[:created] = '2011-01-02 03:04:05'
    t[:body] = 'Hello, world!'
    t.render.should == 
<<-eos
Date: 2011-01-02 03:04:05

Задача: Hello, world!
eos
  end

end


