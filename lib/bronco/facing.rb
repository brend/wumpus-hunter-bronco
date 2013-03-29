
class Facing  
  def initialize(ox, oy)
    @ox, @oy = ox, oy
  end

  UP = Facing.new(0, 1)
  RIGHT = Facing.new(1, 0)
  DOWN = Facing.new(0, -1)
  LEFT = Facing.new(-1, 0)
  
  SEQUENCE = [UP, RIGHT, DOWN, LEFT]
  
  def apply(location)
    [location.first + @ox, location.last + @oy]
  end
  
  def turn
    SEQUENCE[(SEQUENCE.index(self) + 1) % SEQUENCE.length]
  end
  
  def Facing.subtract(a, b)
    x1, y1 = a
    x2, y2 = b
    
    if x1 == x2
      return (y1 > y2) ? UP : DOWN
    elsif y1 == y2
      return (x1 > x2) ? RIGHT : LEFT
    else
      raise ArgumentError.new("Locations must be level, they aren't: #{a}, #{b}")
    end
  end
  
  def inspect
    case self
    when UP
      'UP'
    when RIGHT
      'RIGHT'
    when DOWN
      'DOWN'
    when LEFT
      'LEFT'
    else
      to_s
    end
  end
end