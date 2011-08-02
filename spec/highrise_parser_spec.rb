# coding: utf-8
require 'highrise_redmine/highrise_parser'

describe HighriseRedmine::HighriseParser do

  def read(filename)
    File.open(File.dirname(__FILE__)+filename).read
  end

  it "reads persons sample data correctly" do
    result = HighriseRedmine::HighriseParser.parsePersons(read("/persons.xml"))

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

    result[0][:created].should == DateTime.civil(2007,2,27,3,11,52)
  end

  it "reads persons incomplete sample data correctly" do
    result = HighriseRedmine::HighriseParser.parsePersons(read("/persons-incomplete.xml"))

    result.length.should == 1
    result[0][:title].should == nil
    result[0][:background].should == nil
    result[0][:created].should == DateTime.civil(2007,2,27,3,11,52)
  end

  it "reads persons sample data, retreived from real highrise instance correctly" do
    result = HighriseRedmine::HighriseParser.parsePersons(read("/persons-real.xml"))

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
    result[0][:authorId].should == "524631"
    result[1][:authorId].should == "524631"
  end

  it "reads companies sample data correctly" do
    result = HighriseRedmine::HighriseParser.parseCompanies(read("/companies.xml"))

    result.length.should == 2
    result[0][:id].should == "1"
    result[1][:id].should == "2"
    result[0][:name].should == "Doe Inc."
    result[1][:name].should == "Acme Inc."
  end

  it "reads notes sample data correctly" do 
    content = File.open(File.dirname(__FILE__)+"/notes.xml").read
    result = HighriseRedmine::HighriseParser.parseNotes(content)

    result.length.should == 2
    result[0].should == {
      :created=>DateTime.civil(2006,5,16,17,26,0),
      :body=>'Hello world!',
      :attachments=>[
        {:url=>'https://example.highrisehq.com/files/1', :name=>'picture.png'},
        {:url=>'https://example.highrisehq.com/files/2', :name=>'document.txt'},
      ]
    }
    result[1].should == {
      :created=>DateTime.civil(2006,5,16,17,26,0),
      :body=>'Love, peace and hair grease!',
      :attachments=>[]
    }
  end

  it "reads tasks sample data correctly" do 
    result = HighriseRedmine::HighriseParser.parseTasks(read("/tasks.xml"))

    result.length.should == 2
    result[0].should == {
      :created=>DateTime.civil(2011,7,18,8,43,50),
      :body=>'A timed task for the future',
      :subjectId=>nil,
      :due=>DateTime.civil(2007,3,10,15,11,52),
      :done=>nil
    }
    result[1].should == {
      :created=>DateTime.civil(2011,6,18,8,43,50),
      :body=>'Another task',
      :subjectId=>nil,
      :due=>nil,
      :done=>nil
    }
  end

  it "reads completed tasks data correctly" do 
    result = HighriseRedmine::HighriseParser.parseTasks(read("/tasks-completed.xml"))

    result.length.should == 2
    result[0].should == {
      :created=>DateTime.civil(2011,8,1,13,22,59),
      :body=>'no subject task',
      :subjectId=>nil,
      :due=>DateTime.civil(2011,8,2,4,00,00),
      :done=>DateTime.civil(2011,8,1,13,37,21),
    }
    result[1].should == {
      :created=>DateTime.civil(2011,8,1,13,30,58),
      :body=>'John Doe task',
      :subjectId=>"79593549",
      :due=>DateTime.civil(2011,8,2,4,00,00),
      :done=>DateTime.civil(2011,8,1,13,31,31),
    }
  end

  it "reads users sample data properly" do
    result = HighriseRedmine::HighriseParser.parseUsers(read("/users.xml"))

    result.length.should == 2
    result[0].should == {
      :id=>"1",
      :email=>"john.doe@example.com"
    }
    result[1].should == {
      :id=>"2",
      :email=>"jane.doe@example.com"
    }
  end

end

