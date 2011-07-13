# coding: utf-8
require 'highrise_parser'

def read
  dir = File.dirname(__FILE__) 
  file = File.open(dir+"/persons.xml")
  content = file.read
  h = HighriseParser.new
  h.parse(content)
end

describe HighriseParser do

  result = read

  it "reads sample data" do
    result.length.should == 2
  end
end

