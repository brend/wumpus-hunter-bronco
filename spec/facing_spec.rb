require 'bronco/facing'

describe Facing do
  it "has four directions" do
    Facing::UP
    Facing::RIGHT
    Facing::DOWN
    Facing::LEFT
  end
  
  it "computes facing from one square to another" do
    Facing.subtract([0, 2], [0, 0]).should eq(Facing::UP)
    Facing.subtract([3, 1], [1, 1]).should eq(Facing::RIGHT)
    expect {Facing.subtract([0, 0], [1, 1])}.to raise_error
  end
  
  it "transforms locations" do
    l = [1, 2]
    Facing::UP.apply(l).should eq([1, 3])
    Facing::RIGHT.apply(l).should eq([2, 2])
    Facing::DOWN.apply(l).should eq([1, 1])
    Facing::LEFT.apply(l).should eq([0, 2])
  end
  
  it "turns" do
    Facing::UP.turn.should eq(Facing::RIGHT)
    Facing::RIGHT.turn.should eq(Facing::DOWN)
    Facing::DOWN.turn.should eq(Facing::LEFT)
    Facing::LEFT.turn.should eq(Facing::UP)
  end
end
