require 'highrise_redmine/usermapper'
require 'highrise_redmine/config'

describe HighriseRedmine::UserMapper do

  it "maps usernames properly" do
    m = HighriseRedmine::UserMapper.new(
          HighriseRedmine::Config.new(
            File.open(File.dirname(__FILE__)+"/config_full.yaml").read
          )
        )
    m.map("alice").should == "bob"
    m.map("clara").should == "dave"
  end

  it "returns default mapping if no record found in the config" do
    m = HighriseRedmine::UserMapper.new(
          HighriseRedmine::Config.new(
            File.open(File.dirname(__FILE__)+"/config_full.yaml").read
          )
        )
    m.map("fred").should == "edward"
  end

  it "returns nil when there is no default mapping in the config" do
    m = HighriseRedmine::UserMapper.new(
          HighriseRedmine::Config.new(
            File.open(File.dirname(__FILE__)+"/config_nodefmapping.yaml").read
          )
        )
    m.map("dave").should == nil
  end

  it "works when no mapping in the configuration file" do
    m = HighriseRedmine::UserMapper.new(
          HighriseRedmine::Config.new(
            File.open(File.dirname(__FILE__)+"/config_nomapping.yaml").read
          )
        )
    m.map("dave").should == "alice"
  end

end

