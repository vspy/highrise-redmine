# coding: utf-8
require 'tempfile'  
require 'highrise_redmine/storage'


describe HighriseRedmine::Storage do
  it "stores and then fetches companies" do
    tempFile = Tempfile.new('storage_test')
    s = HighriseRedmine::Storage.new(tempFile)
    s.addCompany("1","Foo LLC")
    s.addCompany("2","Bar LLC")
    s.findCompany("1").should == "Foo LLC"
    s.findCompany("2").should == "Bar LLC"
    s.findCompany("3").should == nil
  end

  it "marks data as processed and finds if it is already processed" do
    tempFile = Tempfile.new('storage_test')
    s = HighriseRedmine::Storage.new(tempFile)
    s.markAsProcessed("a","1")
    s.markAsProcessed("b","2")
    s.isProcessed("a","1").should == true
    s.isProcessed("b","1").should == false
    s.isProcessed("a","2").should == false
    s.isProcessed("b","2").should == true
  end
end
