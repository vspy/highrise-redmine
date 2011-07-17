# coding: utf-8
require 'highrise_redmine/destination'

describe HighriseRedmine::Destination do

  it "deletes issues" do
    http = mock("http")
    http.stub!(:delete)
    http.should_receive(:delete).with(URI.parse('http://example.org/destination/issues/42.xml'), "token", anything())

    dst = HighriseRedmine::Destination.new('http://example.org/destination', http, "token")
    dst.deleteIssue(42)
  end

end



