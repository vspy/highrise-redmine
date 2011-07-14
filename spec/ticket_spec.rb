# coding: utf-8

require 'highrise_redmine/ticket_template'

describe HighriseRedmine::TicketTemplate do
  it "formats ticket properly" do
    t = HighriseRedmine::TicketTemplate.new
    t[:contact] = {
      :firstName => "John",
      :lastName => "Doe",
      :phone => "223-322-223",
      :skype => "john.doe",
      :icq => "424242",
      :title => "Software Engineer",
      :company => "Acme Inc.",
      :tags => [{:first=>true, :value=>"nerd"},
                {:first=>false, :value=>"funny"},
                {:first=>false, :value=>"smart"},
                ],
      :background => "Worked in DARPA."
    }
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
    t[:contact] = {
      :firstName => "John",
      :lastName => "Doe",
      :phone => "223-322-223",
      :icq => "424242",
      :title => "Software Engineer",
      :company => "Acme Inc.",
      :tags => [{:first=>true, :value=>"nerd"},
                {:first=>false, :value=>"funny"},
                {:first=>false, :value=>"smart"},
                ],
      :background => "Worked in DARPA."
    }
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
