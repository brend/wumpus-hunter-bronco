require 'logger'
require 'bronco/states/expedition'
require 'bronco/states/extermination'

class Exploration
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "Exploration: #{msg}\n"
    end
  end
  
  def advance(agent)
    return :grab if agent.senses_glitter?
    return :climb if agent.has_gold? && agent.on_start?
    
    if agent.has_gold?
      @logger.debug("I've got the gold, so I'm getting the hell outta here")
      return transition(Expedition.new(agent.start_location), agent) 
    end    
  
    safe_square = agent.get_safe_square
    if safe_square
      @logger.debug("I will expedition to the safe square #{safe_square.inspect}")
      return transition(Expedition.new(safe_square), agent)
    end
    
    if agent.wumpus_found?
      @logger.debug("I will exterminate the Wumpus")
      return transition(Extermination.new, agent) 
    end  
  
    dangerous_square = agent.get_dangerous_square
    if dangerous_square
      @logger.debug("I will expedition to the dangerous square #{dangerous_square.inspect}")
      return transition(Expedition.new(dangerous_square), agent) 
    end
    
    if agent.on_start?
      @logger.debug("I will leave the cave because I can't do anything any more")
      return :climb 
    end
    
    @logger.debug("I will expedition the the cave entrance - I'm out of options")
    return transition(Expedition.new(agent.start_location), agent)
  end
  
  def transition(state, agent)
    agent.state = state
    state.return_state = self
    state.advance(agent)
  end
end
