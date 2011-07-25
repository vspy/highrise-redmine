# coding: utf-8
require 'highrise_redmine/export'

describe HighriseRedmine::Export do

  it "recovers if something is unclean" do
    src = mock("src")
    storage = mock("storage")
    dst = mock("dst")
    storage.stub!(:recover).and_return(["id1","id2","id3"])
    storage.stub!(:onRecoverFinished)

    src.stub!(:getCompanies).and_return([])
    src.stub!(:getPersons).and_return([])
    src.stub!(:companiesBatchSize).and_return(500)
    src.stub!(:personsBatchSize).and_return(500)
    src.stub!(:notesBatchSize).and_return(25)

    dst.stub!(:deleteIssue)
    dst.should_receive(:deleteIssue).with("id1")
    dst.should_receive(:deleteIssue).with("id2")
    dst.should_receive(:deleteIssue).with("id3")

    storage.should_receive(:onRecoverFinished)

    config = mock("config")
    config.stub!(:projectId).and_return(1)
    config.stub!(:priorityId).and_return(2)
    config.stub!(:trackerId)
    config.stub!(:statusId)

    export = HighriseRedmine::Export.new(config, src, storage, nil, dst)
    export.run
  end

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
    src.stub!(:companiesBatchSize).and_return(3)
    src.stub!(:personsBatchSize).and_return(500)
    src.stub!(:notesBatchSize).and_return(25)
    src.stub!(:getPersons).and_return([])
    
    storage.stub!(:recover).and_return([])
    storage.stub!(:addCompany)
    # first
    storage.should_receive(:addCompany).with("id1","name1")
    # and last
    storage.should_receive(:addCompany).with("id5","name5")

    config = mock("config")
    config.stub!(:projectId).and_return(1)
    config.stub!(:priorityId).and_return(2)
    config.stub!(:trackerId)
    config.stub!(:statusId)

    export = HighriseRedmine::Export.new(config, src, storage, nil, dst)
    export.run
  end

  it "processes all the contacts" do
    src = mock("src")
    storage = mock("storage")
    dst = mock("dst")

    src.stub!(:getPersons)
    src.should_receive(:getPersons).once.with(0).and_return([
      {:id=>"id1",:firstName=>"John",:lastName=>"Doe",:companyId=>"foo",:tags=>["foo","bar"],:created=>DateTime.now},
      {:id=>"id2",:firstName=>"Jane",:lastName=>"Doe",:companyId=>"bar",:tags=>["partner"],:created=>DateTime.now},
      {:id=>"id3",:firstName=>"Alice",:lastName=>"A.",:companyId=>"foo",:created=>DateTime.now}
    ])
    src.should_receive(:getPersons).once.with(3).and_return([
      {:id=>"id4",:firstName=>"Bob",:lastName=>"B.",:companyId=>"acme",:tags=>["foo","bar"],:created=>DateTime.now},
      {:id=>"id5",:firstName=>"Carl",:lastName=>"C.",:created=>DateTime.now}
    ])
    src.stub!(:companiesBatchSize).and_return(500)
    src.stub!(:personsBatchSize).and_return(3)
    src.stub!(:notesBatchSize).and_return(3)
    src.stub!(:tasksBatchSize).and_return(3)
    src.stub!(:getCompanies).and_return([])
    src.stub!(:getNotes)
    src.should_receive(:getNotes).with('id4', 0).and_return([])
    src.should_receive(:getNotes).with('id5', 0).and_return([
      {:body=>'note1', :attachments=>[
            {:url=>'http://example.org/1',:name=>'The Hitchhiker\'s Guide to the Galaxy.pdf'}
          ]},
      {:body=>'note2', :attachments=>[]},
      {:body=>'note3', :attachments=>[]},
    ])
    src.should_receive(:getNotes).with('id5',3).and_return([
      {:body=>'note4', :attachments=>[]},
      {:body=>'note5', :attachments=>[]},
    ])

    ## TODO: check the tasks
    src.should_receive(:getTasks).with('id4', 0).and_return([])
    src.should_receive(:getTasks).with('id5', 0).and_return([])

    storage.should_not_receive(:findCompany).with("foo")
    storage.should_not_receive(:findCompany).with("bar")
    storage.should_receive(:findCompany).once.with("acme").and_return("ACME Inc.")
   
    storage.stub!(:recover).and_return([])
    storage.stub!(:isProcessed)
    storage.should_receive(:isProcessed).once.with("id1").and_return(true)
    storage.should_receive(:isProcessed).once.with("id2").and_return(true)
    storage.should_receive(:isProcessed).once.with("id3").and_return(true)
    storage.should_receive(:isProcessed).once.with("id4").and_return(false)
    storage.should_receive(:isProcessed).once.with("id5").and_return(false)

    storage.stub!(:markAsStarted)
    storage.should_receive(:markAsStarted).once.with("id4")
    storage.should_receive(:markAsStarted).once.with("id5")

    storage.stub!(:markTargetId)
    storage.should_receive(:markTargetId).once.with("id4","redmine0")
    storage.should_receive(:markTargetId).once.with("id5","redmine1")

    storage.stub!(:markAsProcessed)
    storage.should_receive(:markAsProcessed).once.with("id4")
    storage.should_receive(:markAsProcessed).once.with("id5")

    dst.stub!(:createIssue)
    redmineid = 0;
    dst.should_receive(:createIssue).twice.with(instance_of(Hash)).and_return{ |a| r = "redmine#{redmineid}"; redmineid+=1; r }
    dst.stub!(:updateIssue)
    ## TODO: check if saved
    ## TODO: check if attachment is saved & posted
    ## TODO: check if issue updated with note body

    config = mock("config")
    config.stub!(:projectId).and_return(1)
    config.stub!(:priorityId).and_return(2)
    config.stub!(:trackerId)
    config.stub!(:statusId)
 
    export = HighriseRedmine::Export.new(config, src, storage, nil, dst)
    export.run
  end

end


