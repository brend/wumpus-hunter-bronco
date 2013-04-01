class Stop
  include Comparable
  
  attr_accessor :agent, :location, :facing, :action_taken, :target
  attr_reader :path
  
  def initialize(agent, target, location, facing, action_taken = nil, path = [])
    @agent = agent
    @target = target
    @location = location
    @facing = facing
    @action_taken = action_taken
    @path = path + [self]
  end
  
  def successors
    next_square = @facing.apply(@location)
    succ = [Stop.new(@agent, @target, @location, @facing.turn, :turn, path)]
#    if agent.walkable_square_location?(next_square) && !agent.dangerous_square?(next_square)
    if next_square == target || 
       (agent.valid_location?(next_square) &&
        agent.visited_square_location?(next_square))
      succ << Stop.new(@agent, @target, next_square, @facing, :forward, path)
    end
    succ
  end
  
  def ==(s)
    s.location == location && s.facing == facing
  end
  
  def <=>(s)
    cost <=> s.cost
  end
  
  def sequence
    path.collect {|s| s.action_taken}.to_a
  end
  
  def cost
    path.length + distance_to_target
  end
  
  def distance_to_target
    (target.first - location.first + target.last - location.last).abs
  end
  
  def finished?
    location == target
  end
  
  def to_s
    "<Stop at #{location.inspect} facing #{facing.inspect}>"
  end
  
  def inspect
    to_s
  end
end
