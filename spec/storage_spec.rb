# coding: utf-8
require 'tempfile'  
require 'highrise_redmine/storage'

tempFile = Tempfile.new('storage_test')

describe HighriseRedmine::Storage do
  it "stores and then fetches companies" do
    s = HighriseRedmine::Storage.new(tempFile)
    s.addCompany("1","Foo LLC")
    s.addCompany("2","Bar LLC")
    s.findCompany("1").should == "Foo LLC"
    s.findCompany("2").should == "Bar LLC"
    s.findCompany("3").should == nil
  end
end
