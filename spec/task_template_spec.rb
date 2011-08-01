# coding: utf-8
require 'highrise_redmine/note_template'

describe HighriseRedmine::TaskTemplate do

  it "formats task properly" do
    t = HighriseRedmine::TaskTemplate.new
    t[:content] = {
      :createdAt => '2011-01-02 03:04:05',
      :body => 'Hello, world!',
      :due => '2012-02-03 04:05:06',
    }
    t.render.should == 
<<-eos
Date: 2011-01-02 03:04:05

Задача: Hello, world!
Исполнить до: 2012-02-03 04:05:06
eos
  end

  it "formats incomplete task properly" do
    t = HighriseRedmine::TaskTemplate.new
    t[:content] = {
      :createdAt => '2011-01-02 03:04:05',
      :body => 'Hello, world!',
    }
    t.render.should == 
<<-eos
Date: 2011-01-02 03:04:05

Задача: Hello, world!
eos
  end

end


