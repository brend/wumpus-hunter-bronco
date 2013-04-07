require 'bronco/states/expedition'
require 'bronco/logging'

class Extermination
  include Logging
  
  attr_accessor :return_state
  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = global_log_level
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "Extermination: #{msg}\n"
    end
  end
  
  def advance(agent)
    if agent.wumpus_killed?
      @logger.debug("I am finished exterminating because the wumpus has been killed")
      return transition(agent) 
    end
    
    wlos = line_of_sight(agent.wumpus_location)
    
    unless wlos.include?(agent.location)
      @logger.debug("I will walk into the Wumpus' line of sight")
      return walk_to_wumpus(agent, wlos) 
    end
    
    unless agent.facing == Facing.subtract(agent.wumpus_location, agent.location)
      @logger.debug("I must turn to face the Wumpus")
      return :turn
    end
    
    @logger.debug("I will now fire my arrow")
    
    # ready to shoot
    agent.state = return_state
    return :shoot
  end
  
  def transition(agent)
    agent.state = return_state
    return_state.advance(agent)
  end
  
  def line_of_sight(l)
    x, y = l
    r = []
    
    (1..4).each do |i|
      r << [x + i, y] << [x - i, y] << [x, y + i] << [x, y - i]
    end
    
    r
  end
  
  def walk_to_wumpus(agent, wlos)
    @logger.debug("The Wumpus' line of sight is: #{wlos.inspect}")
    wlos.each do |location|
      next unless agent.valid_location?(location) &&
                  agent.safe_square?(location) &&
                  agent.walkable_square_location?(location)
      
      @logger.debug("I will expedition to the Wumpus LOS-square #{location.inspect}")
      
      e = Expedition.new(location)
      e.return_state = self
      agent.state = e
      
      return e.advance(agent)
    end
    
    raise Exception.new("No safe square in Wumpus' line of sight found")
  end
end