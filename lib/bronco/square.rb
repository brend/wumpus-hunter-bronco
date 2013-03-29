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
end
