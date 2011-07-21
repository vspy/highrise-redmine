# coding: utf-8
require 'highrise_redmine/source'

describe HighriseRedmine::Source do

  it "gets and parses companies" do
    response = File.open(File.dirname(__FILE__)+"/companies.xml").read
    http = mock("http")
    http.stub!(:get).and_return(response)
    http.should_receive(:get).with(URI.parse('http://example.org/source/companies.xml?n=42'), "token", anything())

    config = mock("config")
    config.stub!(:srcUrl).and_return('http://example.org/source/')
    config.stub!(:srcAuthToken).and_return('token')

    src = HighriseRedmine::Source.new(config, http)
    result = src.getCompanies(42)

    result.length.should == 2
  end

  it "gets and parses persons" do
    response = File.open(File.dirname(__FILE__)+"/persons.xml").read
    http = mock("http")
    http.stub!(:get).and_return(response)
    http.should_receive(:get).with(URI.parse('http://example.org/source/people.xml?n=42'), "token", anything())

    config = mock("config")
    config.stub!(:srcUrl).and_return('http://example.org/source/')
    config.stub!(:srcAuthToken).and_return('token')

    src = HighriseRedmine::Source.new(config, http)
    result = src.getPersons(42)

    result.length.should == 2
  end


  it "gets and parses notes" do
    response = File.open(File.dirname(__FILE__)+"/notes.xml").read
    http = mock("http")
    http.stub!(:get).and_return(response)
    http.should_receive(:get).with(URI.parse('http://example.org/source/people/123/notes.xml?n=42'), "token", anything())

    config = mock("config")
    config.stub!(:srcUrl).and_return('http://example.org/source/')
    config.stub!(:srcAuthToken).and_return('token')

    src = HighriseRedmine::Source.new(config, http)
    result = src.getNotes(123, 42)

    result.length.should == 2
  end

end


