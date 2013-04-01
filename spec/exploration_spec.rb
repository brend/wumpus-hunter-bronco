require 'bronco/states/exploration'
require 'bronco/states/expedition'
require 'bronco/states/extermination'
require 'bronco/facing'

describe Exploration do
  it "grabs the gold if the agent has sensed it" do
    h = double
    h.stub(:senses_glitter?).and_return(true)
    e = Exploration.new
    e.advance(h).should eq(:grab)
  end
    
  it "expeditions to the start if it has the gold" do
    h = double(:senses_glitter? => false, 
               :has_gold? => true, 
               :on_start? => false,
               :start_location => [3, 3],
               :location => [2, 3],
               :senses_bump? => true,
               :facing => Facing::UP,
               :visited_square_location? => true)
    h.should_receive(:state=).with(kind_of(Expedition))
    e = Exploration.new
    e.advance(h)
  end
  
  it "climbs if agent has the gold and is on start" do
    h = double
    h.stub(:senses_glitter?).and_return(false)
    h.stub(:has_gold?).and_return(true)
    h.stub(:on_start?).and_return(true)
    e = Exploration.new
    e.advance(h).should eq(:climb)
  end
  
  it "expeditions to the start if there are no more options left" do
    h = double(:senses_glitter? => false,
               :has_gold? => false,
               :get_safe_square => nil,
               :wumpus_found? => false,
               :get_dangerous_square => nil,
               :on_start? => false,
               :start_location => [3, 3],
               :location => [0, 2],
               :senses_bump? => false,
               :facing => Facing::UP,
               :visited_square_location? => true)
    h.should_receive(:state=).with(kind_of(Expedition))
    e = Exploration.new
    e.advance(h)
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
  
  it "goes to kill the Wumpus" do
    h = double(:senses_glitter? => false,
               :has_gold? => false,
               :get_safe_square => nil,
               :wumpus_found? => true,
               :wumpus_killed? => false,
               :wumpus_location => [2, 2],
               :location => [2, 1],
               :facing => Facing::DOWN)
    h.should_receive(:state=).with(kind_of(Extermination))
    e = Exploration.new
    e.advance(h)
  end
end
