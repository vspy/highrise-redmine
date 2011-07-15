# coding: utf-8
require 'highrise_redmine/export'

describe HighriseRedmine::Export do

  it "processes all the companies" do
    src = mock("src")
    storage = mock("storage")
    dst = mock("dst")

    src.stub!(:getCompanies)
    src.should_receive(:getCompanies).once.with(0).and_return([
      {:id=>"id1",:name=>"name1"},
      {:id=>"id2",:name=>"name2"},
      {:id=>"id3",:name=>"name3"}
    ])
    src.should_receive(:getCompanies).once.with(3).and_return([
      {:id=>"id4",:name=>"name4"},
      {:id=>"id5",:name=>"name5"}
    ])
    src.stub!(:batchSize).and_return(3)
    src.stub!(:getContacts).and_return([])
    
    storage.stub!(:addCompany)
    # first
    storage.should_receive(:addCompany).with("id1","name1")
    # and last
    storage.should_receive(:addCompany).with("id5","name5")

    export = HighriseRedmine::Export.new(src, storage, dst)
    export.run
  end

  it "processes all the contacts" do
    src = mock("src")
    storage = mock("storage")
    dst = mock("dst")

    src.stub!(:getContacts)
    src.should_receive(:getContacts).once.with(0).and_return([
      {:id=>"id1",:firstName=>"John",:lastName=>"Doe",:companyId=>"foo"},
      {:id=>"id2",:firstName=>"Jane",:lastName=>"Doe",:companyId=>"bar"},
      {:id=>"id3",:firstName=>"Alice",:lastName=>"A.",:companyId=>"foo"}
    ])
    src.should_receive(:getContacts).once.with(3).and_return([
      {:id=>"id4",:firstName=>"Bob",:lastName=>"B.",:companyId=>"acme"},
      {:id=>"id5",:firstName=>"Carl",:lastName=>"C."}
    ])
    src.stub!(:batchSize).and_return(3)
    src.stub!(:getCompanies).and_return([])
    storage.should_not_receive(:getCompany).with("foo")
    storage.should_not_receive(:getCompany).with("bar")
    storage.should_receive(:getCompany).once.with("acme").and_return("ACME Inc.")
   
    storage.stub!(:isProcessed)
    storage.should_receive(:isProcessed).once.with("p","id1").and_return(true)
    storage.should_receive(:isProcessed).once.with("p","id2").and_return(true)
    storage.should_receive(:isProcessed).once.with("p","id3").and_return(true)
    storage.should_receive(:isProcessed).once.with("p","id4").and_return(false)
    storage.should_receive(:isProcessed).once.with("p","id5").and_return(false)

    storage.stub!(:markAsProcessed)
    storage.should_receive(:markAsProcessed).once.with("p","id4")
    storage.should_receive(:markAsProcessed).once.with("p","id5")

    ## TODO: check if saved
 
    export = HighriseRedmine::Export.new(src, storage, dst)
    export.run
  end

end


