# coding: utf-8

require 'highrise_redmine/ticket_template'

describe HighriseRedmine::TicketTemplate do
  it "formats ticket properly" do
    t = HighriseRedmine::TicketTemplate.new
    t[:firstName] = "John"
    t[:lastName] = "Doe"
    t[:emails] = [{:address=>"john.doe@gmail.com", :location=>"Home"}]
    t[:phones] = [{:number=>"223-322-223", :location=>"Work"}]
    t[:messengers] = 
      [{:type=>"Skype", :address=>"john.doe", :location=>"Work"},
       {:type=>"ICQ", :address=>"424242", :location=>"Work"}]
    t[:title] = "Software Engineer"
    t[:company] = "Acme Inc."
    t[:tags] = [{:first=>true, :value=>"nerd"},
                {:first=>false, :value=>"funny"},
                {:first=>false, :value=>"smart"},
                ]
    t[:background] = "Worked in DARPA."
    t.render.should == 
      <<-eos
телефон: 223-322-223
email: john.doe@gmail.com
Skype: john.doe
ICQ: 424242

Software Engineer; Acme Inc.
Теги: nerd, funny, smart

Worked in DARPA.
      eos
  end

  it "doesn't print empty lines when some contacts are missing" do
    t = HighriseRedmine::TicketTemplate.new
    t[:firstName] = "John"
    t[:lastName] = "Doe"
    t[:messengers] = 
      [{:type=>"ICQ", :address=>"424242"}]
    t[:title] = "Software Engineer"
    t[:company] = "Acme Inc."
    t[:tags] = [{:first=>true, :value=>"nerd"},
                {:first=>false, :value=>"funny"},
                {:first=>false, :value=>"smart"},
                ]
    t[:background] = "Worked in DARPA."
    t.render.should == 
      <<-eos
ICQ: 424242

Software Engineer; Acme Inc.
Теги: nerd, funny, smart

Worked in DARPA.
      eos

  end

  it "doesn't print separating blank lines when company title and tags are all missing" do
    t = HighriseRedmine::TicketTemplate.new
    t[:firstName] = "John"
    t[:lastName] = "Doe"
    t[:messengers] = 
      [{:type=>"ICQ", :address=>"424242"}]
    t[:background] = "Worked in DARPA."
    t.render.should == 
      <<-eos
ICQ: 424242

Worked in DARPA.
      eos
  end

  it "doesn't print separating blank lines when background is missing" do
    t = HighriseRedmine::TicketTemplate.new
    t[:firstName] = "John"
    t[:lastName] = "Doe"
    t[:messengers] = 
      [{:type=>"ICQ", :address=>"424242"}]
    t.render.should == 
      <<-eos
ICQ: 424242
      eos

  end
end
