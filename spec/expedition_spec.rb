require 'bronco/states/expedition'
require 'bronco/facing'

describe Expedition do
  it "initializes with a target" do
    e = Expedition.new([2, 1])
    e.target.should eq([2, 1])
  end
  
  it "transitions if it is on target" do
    e = Expedition.new([2, 1])
    h = double
    s = double
    
    h.stub(:location).and_return([2, 1])
    h.should_receive(:state=).with(s)
    s.should_receive(:advance).with(h)
    
    e.return_state = s
    e.advance(h)
  end
    
  it "plots a short path to its target" do
    e = Expedition.new([3, 2])
    h = double(:location => [3, 3], 
               :facing => Facing::UP, 
               :dangerous_square? => false,
               :visited_square_location? => true)
    
    e.plot_path(h).should eq([:turn, :turn, :forward].reverse)
  end
  
  it "can plot complicated, but short paths" do
    e = Expedition.new([0, 0])
    h = double(:dangerous_square? => false)
    
    h.stub!(:visited_square_location?) do |x, y|
      unwalkables = [[1, 2], [1, 3], [1, 4], [3, 2], [4, 3]]
      not unwalkables.include?([x, y])
    end
    
    l = [3, 3]
    f = Facing::UP
    h.stub!(:location) {l}
    h.stub!(:location=) {|xl| l = xl}
    h.stub!(:facing) {f}
    h.stub!(:facing=) {|xf| f = xf}
    
    e.plot_path(h).should eq([:turn, :turn, :turn, :forward, :turn, :turn, :turn, :forward, :forward, :forward, :turn, :forward, :forward].reverse)
  end
  
  it "cancels if the hunter bumps her head" do
    e = Expedition.new([0, 0])
    h = double(:dangerous_square? => false)
    
    h.stub!(:visited_square_location?) do |x, y|
      unwalkables = [[1, 2], [1, 3], [1, 4], [3, 2], [4, 3]]
      not unwalkables.include?([x, y])
    end
    
    l = [3, 3]
    f = Facing::UP
    return_state = double(:advance => :state_has_changed)
    h.stub!(:location) {l}
    h.stub!(:location=) {|xl| l = xl}
    h.stub!(:facing) {f}
    h.stub!(:facing=) {|xf| f = xf}
    h.should_receive(:state=).with(return_state)
    h.stub(:senses_bump?).and_return(false, false, false, false, true)
    
    e.return_state = return_state
    e.plot_path(h)
    # The path should be [:turn, :turn, :turn, :forward, :turn, :turn, :turn, :forward, :forward, :forward, :turn, :forward, :forward].reverse, see above
    e.advance(h).should eq :turn
    e.advance(h).should eq :turn
    e.advance(h).should eq :turn
    e.advance(h).should eq :forward
    e.advance(h).should eq :state_has_changed
  end
  
  it "can find a path to an unvisited square" do
    e = Expedition.new([3, 2])
    h = double(:walkable_square_location? => true)
    l = [3, 3]
    f = Facing::UP
    h.stub!(:location) {l}
    h.stub!(:location=) {|xl| l = xl}
    h.stub!(:facing) {f}
    h.stub!(:facing=) {|xf| f = xf}
    h.stub!(:visited_square_location?) {|l| l == [3, 3]}

    e.plot_path(h).should eq [:turn, :turn, :forward].reverse
  end
end
