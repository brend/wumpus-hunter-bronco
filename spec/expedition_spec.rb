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
  
  # it "returns either TURN or FORWARD" do
  #   e = Expedition.new([2, 1])
  #   h = double
  #   f = double
  #   f.stub(:apply).and_return([1, 0])
  #   f.stub(:turn).and_return(double)
  #   h.stub(:location).and_return([0, 0])
  #   h.stub(:facing).and_return(f)
  #   h.stub(:dangerous_square?).and_return(false)
  #   
  #   a = e.advance(h)
  #   ["TURN", "FORWARD"].should include(a)
  # end
  
  it "plots a short path to its target" do
    e = Expedition.new([3, 2])
    h = double(:location => [3, 3], :facing => Facing::UP, :dangerous_square? => false)
    h.stub!(:walkable_square?) do |x, y|
      (x - 3).abs < 2 && (y - 3).abs < 2
    end
    
    e.plot_path(h).should eq(['TURN', 'TURN', 'FORWARD'])
  end
end
