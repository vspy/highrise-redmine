# coding: utf-8
require 'tempfile'  
require 'highrise_redmine/config'

describe HighriseRedmine::Config do

  it "reads full configuration file" do
    c = HighriseRedmine::Config.new(
      File.open(File.dirname(__FILE__)+"/config_full.yaml").read
    )
    c.srcUrl.should == 'http://example.org/source/'
    c.srcAuthToken.should == 'srcsecret'
    c.dstUrl.should == 'http://example.org/destination/'
    c.defaultToken.should == 'defaultsecret'
    c.attachmentsUrl.should == 'http://example.org/attachments/'
    c.attachmentsDir.should == '~/Documents/attachments/'
    c.projectId.should == 45
    c.trackerId.should == 44
    c.statusId.should == 43
    c.priorityId.should == 42
  end

end

