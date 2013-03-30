require 'bronco/states/extermination'
require 'set'
require 'bronco/facing'

describe Extermination do
  it "advances" do
    e = Extermination.new
    h = double
    h.stub(:wumpus_killed?).and_return(false)
    h.stub(:wumpus_location).and_return([2, 3])
    h.stub(:location).and_return([0, 3])
    h.stub(:facing).and_return(Facing::UP)
    e.advance(h)
  end
  
  it "transitions if wumpus is dead" do
    e = Extermination.new
    h = double
    h.stub(:wumpus_killed?).and_return(true)
    h.stub(:state=).and_return(nil)
    s = double
    s.should_receive(:advance)
    
    e.return_state = s
    e.advance(h)
  end
  
  it "computes line of sight" do
    e = Extermination.new
    
    r1 = Set.new(e.line_of_sight([0, 0]))
    r2 = Set.new(e.line_of_sight([2, 3]))
    
    r1.should eq(Set.new([[-1, 0], [-2, 0], [-3, 0], [-4, 0], [1, 0], [2, 0], [3, 0], [4, 0], [0, -1], [0, -2], [0, -3], [0, -4], [0, 1], [0, 2], [0, 3], [0, 4]]))
    r2.should eq(Set.new([[1, 3], [0, 3], [-1, 3], [-2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [2, 2], [2, 1], [2, 0], [2, -1], [2, 4], [2, 5], [2, 6], [2, 7]]))
  end
  
  it "shoots if wumpus is in the crosshairs" do
    e = Extermination.new
    h = double()
    h.stub(:wumpus_killed?).and_return(false)
    h.stub(:wumpus_location).and_return([2, 3])
    h.stub(:location).and_return([2, 0])
    h.stub(:facing).and_return(Facing::UP)
    h.stub(:state=).and_return(nil)
    
    e.advance(h).should eq(:shoot)
  end
  
  it "turns if wumpus is in the blind spot" do
    e = Extermination.new
    h = double()
    h.stub(:wumpus_killed?).and_return(false)
    h.stub(:wumpus_location).and_return([2, 3])
    h.stub(:location).and_return([2, 0])
    h.stub(:facing).and_return(Facing::LEFT)
    h.stub(:state=).and_return(nil)
    
    e.advance(h).should eq(:turn)
    
  end
end
