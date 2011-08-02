# coding: utf-8
require 'highrise_redmine/source'

describe HighriseRedmine::Source do

  def prepare(filename, suffix)
    response = File.open(File.dirname(__FILE__)+filename).read
    http = mock("http")
    http.stub!(:get).and_return(response)
    http.should_receive(:get).with(URI.parse("http://example.org/source/#{suffix}"), 'token', anything())

    config = mock("config")
    config.stub!(:srcUrl).and_return('http://example.org/source/')
    config.stub!(:srcAuthToken).and_return('token')

    src = HighriseRedmine::Source.new(config, http)
  end

  it "return human urls" do 
    config = mock("config")
    config.stub!(:srcUrl).and_return('http://example.org/source/')
    config.stub!(:srcAuthToken).and_return('token')
    src = HighriseRedmine::Source.new(config, nil)
    src.humanUrlFor(42).should == 'http://example.org/source/people/42'
  end

  it "gets and parses companies" do
    src = prepare('/companies.xml', 'companies.xml?n=42')
    result = src.getCompanies(42)
    result.length.should == 2
  end

  it "gets and parses persons" do
    src = prepare('/persons.xml', 'people.xml?n=42')
    result = src.getPersons(42)
    result.length.should == 2
  end

  it "gets and parses notes" do
    src = prepare('/notes.xml', 'people/123/notes.xml?n=42')
    result = src.getNotes(123, 42)
    result.length.should == 2
  end

  it "gets and parses tasks" do
    src = prepare('/tasks.xml', 'people/123/tasks.xml?n=42')
    result = src.getTasks(123, 42)
    result.length.should == 2
  end

  it "gets and parses completed tasks" do
    src = prepare('/tasks-completed.xml', 'tasks/completed.xml')
    result = src.getCompletedTasks
    result.length.should == 2
  end

end


