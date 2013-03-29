require 'bronco/hunter'
require 'ruby-debug'

describe Hunter do
  it "knows that visited squares aren't dangerous" do
    h = Hunter.new
    h.get_square(1, 2).visit
    h.get_square(0, 0).visit
    
    h.dangerous_square?([1, 2]).should be_false
    h.dangerous_square?([0, 1]).should be_true
    h.dangerous_square?([0, 0]).should be_false
  end
  
  it "has a world of 7x7 unvisited squares" do
    h = Hunter.new
    h.world.length.should eq(7*7)
    h.world.each {|s| s.visited?.should be_false}
  end
  
  it "visits the middle square on the first move" do
    h = Hunter.new
    state = double(:advance => nil)
    h.state = state
    senses = double(:glitter => false, :stench => false, :breeze => false, :bump => false, :scream => false)
    
    h.make_move(senses)
    h.get_square(0, 0).visited?.should be_false
    h.get_square(4, 6).visited?.should be_false
    h.get_square(3, 3).visited?.should be_true
  end
  
  it "knows if there's gold" do
    h = Hunter.new
    state = double(:advance => nil)
    h.state = state
    senses = double(:glitter => true, :stench => false, :breeze => false, :bump => false, :scream => false)
    h.make_move(senses)
    h.senses_glitter?.should be_true
    senses.stub(:glitter => false)
    h.make_move(senses)
    h.senses_glitter?.should be_false
  end
  
  it "knows when it has bagged the gold" do
    h = Hunter.new
    state = double(:advance => 'GRAB')
    h.state = state
    senses = double(:glitter => true, :stench => false, :breeze => false, :bump => false, :scream => false)
    h.has_gold?.should be_false
    h.make_move(senses)
    h.make_move(senses)
    h.has_gold?.should be_true
  end
  
  it "knows the starting position" do
    h = Hunter.new
    state = double(:advance => nil)
    h.state = state
    senses = double(:glitter => false, :stench => false, :breeze => false, :bump => false, :scream => false)
    h.make_move(senses)
    h.on_start?.should be_true
    h.location = [0, 0]
    h.on_start?.should be_false
    h.location = [3, 3]
    h.on_start?.should be_true
  end

  it "gets you a safe square" do
    h = Hunter.new
    state = double(:advance => nil)
    h.state = state
    senses = double(:glitter => false, :stench => false, :breeze => false, :bump => false, :scream => false)
    h.make_move(senses)
    l = h.get_safe_square
    h.safe_square?(l).should be_true
  end  
  
  it "gets you a dangerous square" do
    h = Hunter.new
    state = double(:advance => nil)
    h.state = state
    senses = double(:glitter => false, :stench => true, :breeze => false, :bump => false, :scream => false)
    h.make_move(senses)
    l = h.get_dangerous_square
    l.should be_true
    h.dangerous_square?(l).should be_true
  end
  
  it "knows when the wumpus is dead" do
    h = Hunter.new
    state = double(:advance => nil)
    h.state = state
    senses = double(:glitter => false, :stench => false, :breeze => false, :bump => false, :scream => true)
    h.wumpus_killed?.should be_false
    h.make_move(senses)
    h.wumpus_killed?.should be_true
  end
  
  it "can tell you if a square is safe" do
    h = Hunter.new
    x = double(:safe? => true)
    h.set_square(1, 2, x)
    y = double(:safe? => false)
    h.set_square(3, 0, y)
    h.safe_square?([1, 2]).should be_true
    h.safe_square?([3, 0]).should be_false
  end
  
  it "can tell you if a square is dangerous" do
    h = Hunter.new
    x = double(:dangerous? => true)
    h.set_square(1, 2, x)
    y = double(:dangerous? => false)
    h.set_square(3, 0, y)
    h.dangerous_square?([1, 2]).should be_true
    h.dangerous_square?([3, 0]).should be_false
  end
  
  it "knows the locations of squares" do
    h = Hunter.new
    x = h.get_square(3, 5)
    y = h.get_square(4, 0)
    h.get_location(x).should eq([3, 5])
    h.get_location(y).should eq([4, 0])
  end
  
  it "should be able to make a move" do
    h = Hunter.new
    senses = double(:glitter => false, :stench => false, :breeze => false, :bump => false, :scream => false)
    
    h.make_move(senses)
  end
  
  it "should return only unvisited safe squares" do
    h = Hunter.new
    senses = double(:glitter => false, :stench => false, :breeze => false, :bump => false, :scream => false)
    
    s = h.get_safe_square
    s.nil?.should be_false
    s.visited?.should be_false
  end
  
  it "knows a square's neighbors" do
    h = Hunter.new
    Set.new(h.get_neighbor_locations([3, 3])).should eq(Set.new([[2, 3], [4, 3], [3, 2], [3, 4]]))
    Set.new(h.get_neighbor_locations([0, 0])).should eq(Set.new([[1, 0], [0, 1]]))
  end
end
