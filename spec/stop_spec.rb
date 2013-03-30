require 'set'
require 'bronco/states/expedition'

describe Stop do
  it "initializes with agent, target, location and facing" do
    s = Stop.new(nil, nil, nil, nil)
  end
  
  it "turns and forwards" do
    h = double
    h.should_receive(:dangerous_square?).and_return(false)
    h.should_receive(:walkable_square_location?).and_return(true)
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
  
  it "doesn't forward if dangerous" do
    l = [1, 2]
    lf = double
    h = double
    h.should_receive(:dangerous_square?).with(lf).and_return(true)
    h.should_receive(:walkable_square_location?).and_return(true)
    f = double
    ft = double
    f.stub(:turn).and_return(ft)
    f.stub(:apply).with(l).and_return(lf)
    s = Stop.new(h, nil, l, f)
    succ = s.successors
    
    succ.length.should eq(1)
    succ.should include(Stop.new(h, nil, l, ft))
  end
  
  it "returns the sequence of actions" do
    Stop.new(nil, nil, nil, nil, 'FORWARD', 
      [Stop.new(nil, nil, nil, nil, 'TURN'), 
       Stop.new(nil, nil, nil, nil, 'FORWARD')]).sequence.should eq(['TURN', 'FORWARD', 'FORWARD'])
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
end
