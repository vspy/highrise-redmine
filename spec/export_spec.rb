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

end


