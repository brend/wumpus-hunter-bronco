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
    h = double(:location => [3, 3], :facing => Facing::UP, :dangerous_square? => false)
    h.stub!(:walkable_square_location?) do |x, y|
      (x - 3).abs < 2 && (y - 3).abs < 2
    end
    
    e.plot_path(h).should eq([:turn, :turn, :forward])
  end
  
  it "can plot complicated, but short paths" do
    e = Expedition.new([0, 0])
    h = double(:dangerous_square? => false)
    
    h.stub!(:walkable_square_location?) do |x, y|
      unwalkables = [[1, 2], [1, 3], [1, 4], [3, 2], [4, 3]]
      not unwalkables.include?([x, y])
    end
    
    l = [3, 3]
    f = Facing::UP
    h.stub!(:location) {l}
    h.stub!(:location=) {|xl| l = xl}
    h.stub!(:facing) {f}
    h.stub!(:facing=) {|xf| f = xf}
    
    e.plot_path(h).should eq([:turn, :turn, :turn, :forward, :turn, :turn, :turn, :forward, :forward, :forward, :turn, :forward, :forward])
  end
end
