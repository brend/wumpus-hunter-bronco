require 'bronco/states/exploration'

describe Exploration do
  it "grabs the gold if the agent has sensed it" do
    h = double
    h.stub(:senses_glitter?).and_return(true)
    e = Exploration.new
    e.advance(h).should eq('GRAB')
  end
  
  it "climbs if agent has the gold and is on start" do
    h = double
    h.stub(:senses_glitter?).and_return(false)
    h.stub(:has_gold?).and_return(true)
    h.stub(:on_start?).and_return(true)
    e = Exploration.new
    e.advance(h).should eq('CLIMB')
  end
  
  # it "returns to start if gold is found" do
  #   r = double
  #   r.stub(:return_state=)
  #   r.should_receive(:advance)
  #   Expedition = double
  #   Expedition.should_receive(:new).and_return(r)
  # 
  #   h = double
  #   h.stub(:senses_glitter?).and_return(false)
  #   h.stub(:has_gold?).and_return(true)
  #   h.stub(:on_start?).and_return(false)
  #   h.stub(:state=)
  # 
  #   e = Exploration.new
  #   e.advance(h)
  # end
  # 
  # it "looks for a safe square" do
  #   r = double
  #   r.stub(:return_state=)
  #   r.should_receive(:advance)
  #   Expedition = double
  #   Expedition.should_receive(:new).and_return(r)
  # 
  #   h = double
  #   h.stub(:senses_glitter?).and_return(false)
  #   h.stub(:has_gold?).and_return(false)
  #   h.stub(:state=)
  #   h.should_receive(:get_safe_square).and_return([1, 3])
  # 
  #   e = Exploration.new
  #   e.advance(h)
  # end
  # 
  # it "hunts the wumpus" do
  #   r = double
  #   r.stub(:return_state=)
  #   r.should_receive(:advance)
  #   Extermination = double
  #   Extermination.should_receive(:new).and_return(r)
  # 
  #   h = double
  #   h.stub(:senses_glitter?).and_return(false)
  #   h.stub(:has_gold?).and_return(false)
  #   h.stub(:state=)
  #   h.should_receive(:get_safe_square)
  #   h.should_receive(:wumpus_found?).and_return(true)
  #   h.should_receive(:wumpus_killed?).and_return(false)
  #   h.should_receive(:wumpus_location).and_return([0, 0])
  # 
  #   e = Exploration.new
  #   e.advance(h)
  # end
end
