require 'bronco/square'

describe Square do
  it "has geographical information" do
    s = Square.new
    s.pit.should eq(:maybe)
    s.wumpus.should eq(:maybe)
    s.gold.should eq(:maybe)
    s.walkable.should be_true
  end
  
  it "is dangerous if there may be a pit or the wumpus" do
    s = Square.new
    s.dangerous?.should be_true
    s.pit = :no
    s.dangerous?.should be_true
    s.wumpus = :no
    s.dangerous?.should be_false
    s.pit = :maybe
    s.dangerous?.should be_true
    s.pit = s.wumpus = :yes
    s.dangerous?.should be_false
  end
  
  it "is deadly if there is definitely a pit or the wumpus" do
    s = Square.new
    s.deadly?.should be_false
    s.pit = :yes
    s.deadly?.should be_true
    s.wumpus = :yes
    s.deadly?.should be_true
    s.pit = :no
    s.deadly?.should be_true
    s.wumpus = :no
    s.deadly?.should be_false
  end
  
  it "can have neither pit nor wumpus if it has been visited" do
    s = Square.new
    s.visit
    s.pit.should eq(:no)
    s.wumpus.should eq(:no)
  end
  
  it "is safe if there is neither a wumpus nor a pit" do
    s = Square.new
    s.safe?.should be_false
    s.pit = :no
    s.safe?.should be_false
    s.wumpus = :yes
    s.safe?.should be_false
    s.wumpus = :no
    s.safe?.should be_true
  end
  
  it "should be visited after being visited" do
    s = Square.new
    s.visited?.should be_false
    s.visit
    s.visited?.should be_true
  end
  
  it "can be properly walled up" do
    s = Square.new
    s.wall_up
    s.wumpus.should eq(:no)
    s.pit.should eq(:no)
    s.walkable.should be_false
  end
  
  it "has a dangerousness dependent on the number of perils" do
    s = Square.new
    # Wumpus possible, Pit possible
    s.dangerousness.should eq 2
    s.wumpus = :no
    # Wumpus impossible, Pit possible
    s.dangerousness.should eq 1
    # Wumpus impossible, Pit impossible
    s.pit = :no
    s.dangerousness.should eq 0
    # Wumpus possible, Pit impossible
    s.wumpus = :maybe
    s.dangerousness.should eq 1
    # Wumpus certain
    s.wumpus = :yes
    s.dangerousness.should eq 9001
    # Pit certain
    s.wumpus = :no
    s.pit = :yes
    s.dangerousness.should eq 9001
  end
end
