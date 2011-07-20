# coding: utf-8

require 'highrise_redmine/ticket_template'

describe HighriseRedmine::TicketTemplate do
  it "formats ticket properly" do
    t = HighriseRedmine::TicketTemplate.new
    t[:firstName] = "John"
    t[:lastName] = "Doe"
    t[:phone] = "223-322-223"
    t[:skype] = "john.doe"
    t[:icq] = "424242"
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
skype: john.doe
icq: 424242

Software Engineer; Acme Inc.
Теги: nerd, funny, smart

Worked in DARPA.
      eos
  end

  it "don't print empty lines when some contacts are missing" do
    t = HighriseRedmine::TicketTemplate.new
    t[:firstName] = "John"
    t[:lastName] = "Doe"
    t[:phone] = "223-322-223"
    t[:icq] = "424242"
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
icq: 424242

Software Engineer; Acme Inc.
Теги: nerd, funny, smart

Worked in DARPA.
      eos

  end
end
