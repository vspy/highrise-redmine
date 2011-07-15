# coding: utf-8
require 'tempfile'  
require 'highrise_redmine/config'

describe HighriseRedmine::Config do

  it "reads full configuration file" do
    c = HighriseRedmine::Config.new(
      File.open(File.dirname(__FILE__)+"/config_full.yaml").read
    )
    c.src.should == 'http://example.org/source/'
    c.dst.should == 'http://example.org/destination/'
  end

end

