require 'bronco/states/expedition'
require 'bronco/states/extermination'

class Exploration
  def advance(agent)
    return :shoot if agent.senses_glitter?
    return :shoot if agent.has_gold? && agent.on_start?
    
    return transition(Expedition.new, agent) if agent.has_gold?
      
    safe_square = agent.get_safe_square
    return transition(Expedition.new(safe_square), agent) if safe_square
    
    return transition(Extermination.new, agent) if agent.wumpus_found?
    
    dangerous_square = agent.get_dangerous_square
    return transition(Expedition.new(dangerous_square), agent) if dangerous_square
    
    return :shoot if agent.on_start?
    
    return transition(Expedition.new(agent.start_location), agent)
  end
  
  def transition(state, agent)
    agent.state = state
    state.return_state = self
    state.advance(agent)
  end
end
