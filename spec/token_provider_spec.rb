require 'highrise_redmine/token_provider'
require 'highrise_redmine/config'

describe HighriseRedmine::TokenProvider do

  it "maps usernames properly" do
    m = HighriseRedmine::TokenProvider.new(
          HighriseRedmine::Config.new(
            File.open(File.dirname(__FILE__)+"/config_full.yaml").read
          )
        )
    m.getToken("alice").should == "alicesecret"
    m.getToken("clara").should == "clarasecret"
  end

  it "returns default mapping if no record found in the config" do
    m = HighriseRedmine::TokenProvider.new(
          HighriseRedmine::Config.new(
            File.open(File.dirname(__FILE__)+"/config_full.yaml").read
          )
        )
    m.getToken("fred").should == "defaultsecret"
  end

  it "works when no mapping in the configuration file" do
    m = HighriseRedmine::TokenProvider.new(
          HighriseRedmine::Config.new(
            File.open(File.dirname(__FILE__)+"/config_nomapping.yaml").read
          )
        )
    m.getToken("dave").should == "defaultsecret"
  end

end

