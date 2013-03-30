require 'bronco/states/exploration'
require 'bronco/square'
require 'bronco/facing'
require 'set'

class Hunter
  attr_accessor :state, :world, :location, :facing, :last_action
  attr_reader :wumpus_location
  
  def initialize
    @state = Exploration.new
    @world = (0...7*7).collect {Square.new}.to_a
    @last_action = nil
    @location = [3, 3]
    @senses_glitter = false
    @has_gold = false
    @wumpus_location = nil
    @facing = Facing::UP
  end
  
  def make_move(senses)
    update_world(senses)
    @last_action = state.advance(self)
  end
  
  def update_world(senses)
    xs = get_square(*location)
    xs.visit
    
    # TODO Walls here
    handle_movement(senses)
    @facing = @facing.turn if @last_action == :turn
    @senses_glitter = senses.glitter
    @has_gold = @last_action == :shoot
    @wumpus_killed = true if senses.scream
    
    detect_wumpus(senses)
    detect_pit(senses)
    
    @wumpus_can_be_killed = !@wumpus_killed && wumpus_location
  end
  
  def handle_movement(senses)
    return unless last_action == :forward
    
    if senses.bump
      # Mark 'walls'
      wall = @facing.get_wall(location)
      wall.each {|x, y| get_square(x, y).wall_up}
    else
      @location = @facing.apply(location)
    end
  end
  
  def detect_wumpus(senses)
    if senses.stench
      # Clear Wumpus possibility from all squares but the neighboring ones
      0.upto(6) do |y|
        0.upto(6) do |x|
          next if neighbors?([x, y], location)
          ys = get_square(x, y)
          ys.wumpus = :no
        end
      end    
    else
      # Clear Wumpus possibility from the surrounding squares
      get_neighbor_locations(location).each {|x, y| get_square(x, y).wumpus = :no}
    end
    
    # Note: If a square has been visited, 
    # "wumpus = :no" has already been executed.
    possible_squares = @world.select {|s| s.wumpus == :maybe}
  
    if possible_squares.length == 1
      possible_squares.first.wumpus = :yes
      @wumpus_location = get_location(possible_squares.first)
    end
  end
  
  def wumpus_found?
    not @wumpus_location.nil?
  end
  
  def neighbors?(location1, location2)
    x, y = location1
    a, b = location2
    
    (x == a && (y - b).abs == 1) || (y == b && (x - a).abs == 1)
  end
  
  def detect_pit(senses)
    if senses.breeze
      # To be implemented
    else
      # Clear Pit possibility from the surrounding squares
      get_neighbor_locations(location).each {|x, y| get_square(x, y).pit = :no}
    end
  end
  
  def get_neighbor_locations(l)
    x, y = l
    neighbors = []
    0.upto(6) do |j|
      0.upto(6) do |i|
        neighbors << [i, j] if neighbors?([i, j], l)
      end
    end
    neighbors
  end
  
  def dangerous_square?(s)
    not visited_squares.include?(s)
  end
  
  def walkable_square_location?(l)
    s = get_square(*l)
    s.walkable
  end
  
  def get_square(x, y)
    raise ArgumentError.new("Bounds!") if x < 0 || x >= 7 || y < 0 || y >= 7
    @world[x + 7 * y]
  end
  
  def set_square(x, y, v)
    raise ArgumentError.new("Bounds!") if x < 0 || x >= 7 || y < 0 || y >= 7
    @world[x + 7 * y] = v
  end
  
  def get_dangerous_square
    # TODO: Sort by dangerousness, proximity to hunter
    get_all_dangerous_squares.first
  end
  
  def get_all_dangerous_squares
    result = []
    0.upto(6) do |y|
      0.upto(6) do |x|
        s = get_square(x, y)
        result << [x, y] if neighbors?(location, [x, y]) && s.dangerous? && s.walkable && !s.visited?
      end
    end
    result
  end

  def get_all_safe_squares
    result = []
    0.upto(6) do |y|
      0.upto(6) do |x|
        s = get_square(x, y)
        result << [x, y] if neighbors?(location, [x, y]) && s.safe? && s.walkable && !s.visited?
      end
    end
    result
  end
  
  def get_safe_square
    # TODO: Sort by proximity to hunter
    get_all_safe_squares.first
  end
  
  def get_location(square)
    0.upto(6) do |y|
      0.upto(6) do |x|
        return [x, y] if square == get_square(x, y)
      end
    end
  end
  
  def senses_glitter?
    @senses_glitter
  end
  
  def has_gold?
    @has_gold
  end
  
  def on_start?
    location == [3, 3]
  end
  
  def safe_square?(l)
    get_square(l.first, l.last).safe?
  end
  
  def dangerous_square?(l)
    get_square(l.first, l.last).dangerous?
  end
  
  def wumpus_killed?
    @wumpus_killed
  end
  
  def to_s
    "Bronco"
  end
  
  def inspect
    to_s
  end
end
