# coding: utf-8
require 'highrise_redmine/destination'

describe HighriseRedmine::Destination do

  it "deletes issues" do
    http = mock("http")
    http.stub!(:delete)
    http.should_receive(:delete).with(URI.parse('http://example.org/destination/issues/42.xml'), "token", anything())

    config = mock("config")
    config.stub!(:dstUrl).and_return('http://example.org/destination/')
    config.stub!(:dstAuthToken).and_return('token')

    dst = HighriseRedmine::Destination.new(config, http)
    dst.deleteIssue(42)
  end

end



