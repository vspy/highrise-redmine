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
    s.markAsStarted("1")
    s.markAsStarted("2")
    s.isProcessed("1").should == false
    s.isProcessed("2").should == false
    s.isProcessed("3").should == false
    s.markAsProcessed("1")
    s.markAsProcessed("2")
    s.isProcessed("1").should == true
    s.isProcessed("2").should == true
    s.isProcessed("3").should == false
  end

  it "finds target ids to delete when processed incompletely" do
    tempFile = Tempfile.new('storage_test')
    s = HighriseRedmine::Storage.new(tempFile)

    s.isProcessed("1").should == false
    s.isProcessed("2").should == false

    s.markAsStarted("1")
    s.markAsStarted("2")

    s.isProcessed("1").should == false
    s.isProcessed("1").should == false

    s.recover.should == []

    # mark as started again, because recover should drop old 
    # records without target id
    s.markAsStarted("1")
    s.markAsStarted("2")
    s.markTargetId("1","redmine_1")
    s.recover.should == ["redmine_1"]


    # mark as started again, because recover should drop old 
    # records without target id
    s.markAsStarted("2")
    s.markTargetId("2","redmine_2")
    s.recover.should == ["redmine_1","redmine_2"]

    s.onRecoverFinished
    s.recover.should == []
  end

  it "reports only unfinished records" do
    tempFile = Tempfile.new('storage_test')
    s = HighriseRedmine::Storage.new(tempFile)


    s.markAsStarted("1")
    s.markAsStarted("2")
    s.markTargetId("1","redmine_1")
    s.markTargetId("2","redmine_2")
    s.markAsProcessed("1")
    s.recover.should == ["redmine_2"]
  end

end
