# coding: utf-8
require 'highrise_redmine/highrise_parser'

describe HighriseRedmine::HighriseParser do

  it "reads persons sample data correctly" do
    dir = File.dirname(__FILE__) 
    file = File.open(dir+"/persons.xml")
    content = file.read
    result = HighriseRedmine::HighriseParser.parsePersons(content)

    result.length.should == 2
    result[0][:id].should == "1"
    result[1][:id].should == "2"
    result[0][:firstName].should == "John"
    result[1][:firstName].should == "Jane"
  end

  it "reads companies sample data correctly" do
    dir = File.dirname(__FILE__) 
    file = File.open(dir+"/companies.xml")
    content = file.read
    result = HighriseRedmine::HighriseParser.parseCompanies(content)

    result.length.should == 2
    result[0][:id].should == "1"
    result[1][:id].should == "2"
    result[0][:name].should == "Doe Inc."
    result[1][:name].should == "Acme Inc."
  end

end

