class Square
  attr_accessor :pit, :wumpus, :gold, :walkable
  
  def initialize
    @pit = @wumpus = @gold = @start = :maybe
    @visited = false
    @walkable = true
  end
  
  def dangerous?
    wumpus == :maybe || pit == :maybe
  end
  
  def deadly?
    wumpus == :yes || pit == :yes
  end
  
  def safe?
    wumpus == :no && pit == :no
  end
  
  def visit
    self.wumpus = self.pit = :no
    @visited = true
  end
  
  def visited?
    @visited
  end
  
  def wall_up
    @walkable = false
    @pit = @wumpus = :no
  end
  
  def dangerousness
    return 9001 if pit == :yes || wumpus == :yes
    d = 0
    d += 1 if wumpus == :maybe
    d += 1 if pit == :maybe
    d
  end
  
  def inspect
    "{wu=#{wumpus},pi=#{pit},go=#{gold},wa=#{walkable},vi=#{visited?}}"
  end
  
  def to_s
    inspect
  end
end
