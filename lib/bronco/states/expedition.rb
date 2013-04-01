require 'bronco/stop'

class Expedition
  attr_accessor :target, :return_state
  
  def initialize(target)
    @target = target
    @path = nil
  end
  
  def advance(agent)
    return transition(agent) if agent.location == target
    
    @path = plot_path(agent) unless @path
    
    # puts "", "I have plotted a path: #{@path.inspect}"
    
    raise Exception.new("Computed empty path from #{agent.location.inspect} to #{target.inspect}") if @path.nil? || @path.empty?
    
    return @path.pop
  end
  
  def transition(agent)
    agent.state = return_state
    return return_state.advance(agent)
  end
  
  def plot_path(agent)
    location = agent.location
    facing = agent.facing
    
    fringe = [Stop.new(agent, target, location, facing)]
    visited = []
    
    until fringe.empty?
      puts "", "The fringe is: #{fringe.inspect}"
      fringe.sort!.reverse!
      n = fringe.pop
      puts "Selecting #{n} for expansion"
      puts "Target reached: #{n.path.inspect}" if n.finished?
      return get_path_actions(n.path) if n.finished?
      visited << n
      n.successors.each {|s| fringe << s unless visited.include?(s)}
    end
    
    raise Exception.new("Could not compute path from #{location.inspect} to #{target.inspect}")
  end
  
  def get_path_actions(path)
    path.collect(&:action_taken).drop(1)
  end
end
