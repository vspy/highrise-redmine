# coding: utf-8
require 'highrise_redmine/export'

describe HighriseRedmine::Export do

  it "recovers if something is unclean" do
    src = mock("src")
    storage = mock("storage")
    dst = mock("dst")
    storage.stub!(:recover).and_return(["id1","id2","id3"])
    storage.stub!(:onRecoverFinished)

    src.stub!(:getUsers).and_return([])
    src.stub!(:getCompanies).and_return([])
    src.stub!(:getCompletedTasks).and_return([])
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
    config.stub!(:attachmentsUrl).and_return('http://example.org/files/')
    config.stub!(:attachmentsDir)
    config.stub!(:projectId).and_return(1)
    config.stub!(:priorityId).and_return(2)
    config.stub!(:trackerId)
    config.stub!(:statusId)
    config.stub!(:customFields)
    config.stub!(:urlFieldId)
    config.stub!(:assignedTo)

    export = HighriseRedmine::Export.new(config, src, storage, dst)
    export.run
  end

  it "processes all users" do
    src = mock("src")
    storage = mock("storage")
    dst = mock("dst")

    src.stub!(:getUsers).and_return([
      {:id=>"1", :email=>"alice@example.org"},
      {:id=>"2", :email=>"bob@example.org"},
    ])
    src.stub!(:getCompanies).and_return([])
    src.stub!(:getCompletedTasks).and_return([])
    src.stub!(:companiesBatchSize).and_return(500)
    src.stub!(:personsBatchSize).and_return(500)
    src.stub!(:notesBatchSize).and_return(25)
    src.stub!(:getPersons).and_return([])
    
    storage.stub!(:recover).and_return([])
    storage.stub!(:addUser)
    storage.should_receive(:addUser).with("1","alice@example.org")
    storage.should_receive(:addUser).with("2","bob@example.org")

    config = mock("config")
    config.stub!(:attachmentsUrl).and_return('http://example.org/files/')
    config.stub!(:attachmentsDir)
    config.stub!(:projectId).and_return(1)
    config.stub!(:priorityId).and_return(2)
    config.stub!(:trackerId)
    config.stub!(:statusId)
    config.stub!(:customFields)
    config.stub!(:urlFieldId)
    config.stub!(:assignedTo)

    export = HighriseRedmine::Export.new(config, src, storage, dst)
    export.run  
  end

  it "processes all the companies" do
    src = mock("src")
    storage = mock("storage")
    dst = mock("dst")

    src.stub!(:getUsers).and_return([])
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
    src.stub!(:getCompletedTasks).and_return([])
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
    config.stub!(:attachmentsUrl).and_return('http://example.org/files/')
    config.stub!(:attachmentsDir)
    config.stub!(:projectId).and_return(1)
    config.stub!(:priorityId).and_return(2)
    config.stub!(:trackerId)
    config.stub!(:statusId)
    config.stub!(:customFields)
    config.stub!(:urlFieldId)
    config.stub!(:assignedTo)

    export = HighriseRedmine::Export.new(config, src, storage, dst)
    export.run
  end

  it "processes all the contacts" do
    src = mock("src")
    storage = mock("storage")
    dst = mock("dst")

    src.stub!(:getUsers).and_return([])
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
    src.stub!(:getCompletedTasks).and_return([])
    src.stub!(:personsBatchSize).and_return(3)
    src.stub!(:notesBatchSize).and_return(3)
    src.stub!(:tasksBatchSize).and_return(3)
    src.stub!(:getCompanies).and_return([])
    src.stub!(:getNotes)

    src.should_receive(:getNotes).with('id4', 0).and_return([
      {:body=>'id4note1', :attachments=>[]},
      {:body=>'id4note2', :attachments=>[]},
    ])

    src.should_receive(:getNotes).with('id5', 0).and_return([
      {:body=>'id5note1', :attachments=>[
            {:url=>'http://example.org/1',:name=>'The Hitchhiker\'s Guide to the Galaxy.pdf'}
          ]},
      {:body=>'id5note2', :attachments=>[]},
      {:body=>'id5note3', :attachments=>[]},
    ])
    src.should_receive(:getNotes).with('id5',3).and_return([
      {:body=>'id5note4', :attachments=>[]},
      {:body=>'id5note5', :attachments=>[]},
    ])

    ## TODO: check the tasks
    src.should_receive(:getTasks).with('id4', 0).and_return([
      {:body=>'id4task1'},
      {:body=>'id4task2'},
      {:body=>'id4task3'},
    ])
    src.should_receive(:getTasks).with('id4', 3).and_return([
      {:body=>'id4task4'},
      {:body=>'id4task5'},
      {:body=>'id4task6'},
    ])
    src.should_receive(:getTasks).with('id4', 6).and_return([
      {:body=>'id4task7'},
    ])
    src.should_receive(:getTasks).with('id5', 0).and_return([
      {:body=>'id5task1'},
      {:body=>'id5task2'},
    ])

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
    dst.should_receive(:createIssue).twice.with(instance_of(Hash)).and_return{ r = "redmine#{redmineid}"; redmineid+=1; r }
    dst.stub!(:updateIssue)
    dst.should_receive(:updateIssue).with("redmine0", anything()).exactly(2+7).times
    dst.should_receive(:updateIssue).with("redmine1", anything()).exactly(5+2).times

    config = mock("config")
    config.stub!(:attachmentsUrl).and_return('http://example.org/files/')
    config.stub!(:attachmentsDir)

    config.stub!(:projectId).and_return(1)
    config.stub!(:priorityId).and_return(2)
    config.stub!(:trackerId)
    config.stub!(:statusId)
    config.stub!(:customFields)
    config.stub!(:urlFieldId)
    config.stub!(:assignedTo)

    src.stub!(:download)
    src.should_receive(:download).with("http://example.org/1", anything())
 
    export = HighriseRedmine::Export.new(config, src, storage, dst)
    export.run
  end

  it "sort updates in a chronological order" do 
    src = mock("src")
    src.stub!(:companiesBatchSize).and_return(500)
    src.stub!(:personsBatchSize).and_return(3)
    src.stub!(:notesBatchSize).and_return(3)
    src.stub!(:tasksBatchSize).and_return(3)
    config = mock("config")
    config.stub!(:attachmentsUrl).and_return('http://example.org/files/')
    config.stub!(:attachmentsDir)

    config.stub!(:projectId).and_return(1)
    config.stub!(:priorityId).and_return(2)
    config.stub!(:trackerId)
    config.stub!(:statusId)
    config.stub!(:customFields)
    config.stub!(:urlFieldId)
    config.stub!(:assignedTo)

    data = [
      {:type=>:task, :created=>DateTime.civil(2011,02,01,00,00,00)},
      {:type=>:task, :created=>DateTime.civil(2011,03,01,00,00,00)},
      {:type=>:note, :created=>DateTime.civil(2011,01,01,00,00,00)},
      {:type=>:note},
    ]
    HighriseRedmine::Export.new(config, src, nil, nil).sortUpdates(data).should == [
      {:type=>:note},
      {:type=>:note, :created=>DateTime.civil(2011,01,01,00,00,00)},
      {:type=>:task, :created=>DateTime.civil(2011,02,01,00,00,00)},
      {:type=>:task, :created=>DateTime.civil(2011,03,01,00,00,00)},
    ]
  end

end


