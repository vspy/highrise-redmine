# coding: utf-8
require 'tempfile'  
require 'highrise_redmine/config'

describe HighriseRedmine::Config do

  it "reads full configuration file" do
    c = HighriseRedmine::Config.new(
      File.open(File.dirname(__FILE__)+"/config_full.yaml").read
    )
    c.srcUrl.should == 'http://example.org/source/'
    c.srcAuthToken.should == 'secret'
    c.dst.should == 'http://example.org/destination/'
  end

end

