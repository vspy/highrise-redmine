# coding: utf-8
require 'tempfile'  
require 'highrise_redmine/http'

describe HighriseRedmine::Http do

  it "processes paths with empty query" do
    HighriseRedmine::Http.new.path(
      URI.parse('http://example.org/source/')
    ).should == "/source/"
  end

  it "processes paths with empty query" do
    HighriseRedmine::Http.new.path(
      URI.parse('http://example.org/source/?foo=bar')
    ).should == "/source/?foo=bar"
  end

end


