require 'bronco/states/exploration'

describe Exploration do
  it "grabs the gold if the agent has sensed it" do
    h = double
    h.stub(:senses_glitter?).and_return(true)
    e = Exploration.new
    e.advance(h).should eq(:grab)
  end
  
  it "climbs if agent has the gold and is on start" do
    h = double
    h.stub(:senses_glitter?).and_return(false)
    h.stub(:has_gold?).and_return(true)
    h.stub(:on_start?).and_return(true)
    e = Exploration.new
    e.advance(h).should eq(:climb)
  end
  
  it "climbs if there are no more options left and the agent is on start" do
    h = double(:senses_glitter? => false,
               :has_gold? => false,
               :get_safe_square => nil,
               :wumpus_found? => false,
               :get_dangerous_square => nil,
               :on_start? => true)
    e = Exploration.new
    e.advance(h).should eq :climb
  end
end
