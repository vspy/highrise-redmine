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
    result[0][:lastName].should == "Doe"
    result[1][:lastName].should == "Doe"
    result[0][:title].should == "Stand-in"
    result[1][:title].should == "Assistant"
    result[0][:tags].should == ["Partner", "Blabber"]
    result[1][:tags].should == []
    result[0][:background].should == "A popular guy for random data"
    result[1][:background].should == "A popular girl for random data"
  end

  it "reads persons sample data, retreived from real highrise instance correctly" do
    dir = File.dirname(__FILE__) 
    file = File.open(dir+"/persons-real.xml")
    content = file.read
    result = HighriseRedmine::HighriseParser.parsePersons(content)

    result.length.should == 2
    result[0][:id].should == "78334470"
    result[1][:id].should == "78705072"
    result[0][:firstName].should == "Firstname1"
    result[1][:firstName].should == "Firstname2"
    result[0][:lastName].should == "Lastname1"
    result[1][:lastName].should == "Lastname2"
    result[0][:title].should == nil
    result[1][:title].should == "Tech.Writing dept. lead"
    result[0][:tags].should == []
    result[1][:tags].should == []
    result[0][:background].should == nil
    result[1][:background].should == "hey! that is the background!!!"
    result[0][:messengers].should == [{:type=>'Skype', :address=>'skypeid1', :location=>"Work"},
                                      {:type=>'Skype', :address=>'skypeid1a', :location=>"Work"}]
    result[1][:messengers].should == [{:type=>'Skype', :address=>'skypeid2', :location=>"Work"}]

    result[0][:phones].should == []
    result[1][:phones].should == [{:number=>'+79130000000', :location=>"Mobile"}]
    result[0][:emails].should == []
    result[1][:emails].should == [{:address=>'somebody@example.org', :location=>"Work"}]

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

