require 'set'
require 'bronco/states/expedition'

describe Stop do
  it "initializes with agent, target, location and facing" do
    s = Stop.new(nil, nil, nil, nil)
  end
  
  it "turns and forwards" do
    h = double(:visited_square_location? => true, :valid_location? => true)
    l = [1, 2]
    lf = double
    f = double
    ft = double
    f.stub(:turn).and_return(ft)
    f.stub(:apply).with(l).and_return(lf)
    s = Stop.new(h, nil, l, f)
    succ = s.successors
    
    succ.length.should eq(2)
    succ.should include(Stop.new(nil, nil, l, ft))
    succ.should include(Stop.new(nil, nil, lf, f))
  end
  
  it "doesn't forward if unvisited" do
    h = double(:valid_location? => true)
    h.stub!(:visited_square_location?) {|x, y| x == 6 && y == 5}
    t = [6, 5]
    l = [1, 1]
    f = Facing::UP
    s = Stop.new(h, t, l, f)
    succ = s.successors
    succ.length.should eq(1)
  end
  
  it "returns the sequence of actions" do
    Stop.new(nil, nil, nil, nil, :forward, 
      [Stop.new(nil, nil, nil, nil, :turn), 
       Stop.new(nil, nil, nil, nil, :forward)]).sequence.should eq([:turn, :forward, :forward])
  end
  
  it "is finished iff on target" do
    e = Stop.new(nil, [0, 3], [1, 3], nil)
    e.finished?.should be_false
    
    e.location = [0, 3]
    e.finished?.should be_true
  end
  
  it "has a cost equal to the path length plus distance to target" do
    Stop.new(nil, [2, 1], [2, 1], nil).cost.should eq(1)
    Stop.new(nil, [2, 1], [2, 1], nil, nil, []).cost.should eq(1)
    Stop.new(nil, [2, 1], [2, 1], nil, nil, [Stop.new(nil, nil, nil, nil), Stop.new(nil, nil, nil, nil)]).cost.should eq(3)
    Stop.new(nil, [2, 1], [3, 2], nil, nil, [Stop.new(nil, nil, nil, nil), Stop.new(nil, nil, nil, nil)]).cost.should eq(5)
  end
  
  it "compares to another stop by cost" do
    e = Stop.new(nil, [2, 1], [2, 1], nil, nil, [nil, nil])
    x = Stop.new(nil, [1, 3], [1, 3], nil, nil, [nil, nil])
    y = Stop.new(nil, [2, 1], [2, 1], nil, nil, [nil, nil, nil])
    
    (e <= x).should be_true
    (e < x).should be_false
    (e < y).should be_true
    (y < x).should be_false
  end
  
  it "is equal to another stop iff location and facing are equal" do
    f1 = double
    f2 = double
    e = Stop.new(nil, [2, 1], [2, 1], f1, nil, [nil, nil])
    x = Stop.new(nil, [1, 3], [1, 3], f1, nil, [nil, nil])
    y = Stop.new(nil, [2, 1], [2, 1], f2, nil, [nil, nil, nil])
    
    (e == e).should be_true
    (e == x).should be_false
    (e == y).should be_false
  end
  
  it "doesn't overstep the map's bounds" do
    h = double
    h.stub!(:valid_location?) {|x, y| (0...7).include?(x) && (0...7).include?(y)}
    h.should_not_receive(:visited_square_location?)
    t = [3, 4]
    l = [2, 6]
    f = Facing::UP
    s = Stop.new(h, t, l, f)
    s.successors.length.should eq 1
  end
end
