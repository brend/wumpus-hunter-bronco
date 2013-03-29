# require 'wumpus/action'
require 'bronco/states/expedition'

class Extermination
  attr_accessor :return_state
  
  
  # DEBUG
  module Action
    TURN = "TURN"
    SHOOT = "SHOOT"
  end
  
  def advance(agent)
    return transition(agent) if agent.wumpus_killed?
    
    wlos = line_of_sight(agent.wumpus_location)
    
    return walk_to_wumpus(agent, wlos) unless wlos.include?(agent.location)
    
    return Action::TURN unless agent.facing == Facing.subtract(agent.wumpus_location, agent.location)
    
    # ready to shoot
    agent.state = return_state
    return Action::SHOOT
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
    wlos.each do |location|
      next unless agent.safe_square?(location)
      
      e = Expedition.new(location)
      e.return_state = self
      agent.state = e
      
      return e.advance(agent)
    end
    
    raise Exception.new("No safe square in Wumpus' line of sight found")
  end
end