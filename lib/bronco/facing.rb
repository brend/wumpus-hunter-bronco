
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
  
  def get_wall(l)
    x, y = l
    result = []
    
    if @ox == 0
      yrange = (@oy > 0) ? (y + @oy .. 6) : (0 .. y + @oy)
      yrange.each do |wy|
        result += 0.upto(6).collect {|i| [i, wy]}
      end
      yrange2 = (@oy > 0) ? (0 .. y - 4) : (y + 4 .. 6)
      yrange2.each do |wy|
        result += 0.upto(6).collect {|i| [i, wy]}
      end
    elsif @oy == 0
      xrange = (@ox > 0) ? (x + @ox .. 6) : (0 .. x + @ox)
      xrange.each do |wx|
        result += 0.upto(6).collect {|i| [wx, i]}
      end
      xrange2 = (@ox > 0) ? (0 .. x - 4) : (x + 4 .. 6)
      xrange2.each do |wx|
        result += 0.upto(6).collect {|i| [wx, i]}
      end
    else
      raise Exception.new('Invalid facing')
    end
    
    result
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