require 'bronco/stop'
require 'bronco/logging'

class Expedition
  include Logging
  
  attr_accessor :target, :return_state
  
  def initialize(target)
    @target = target
    @path = nil
    @first_turn = true
    @logger = Logger.new(STDOUT)
    @logger.level = global_log_level
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "Expedition: #{msg}\n"
    end
  end
  
  def advance(agent)
    @logger.debug("I will find a way to #{target.inspect}") if @first_turn
    
    if agent.location == target
      @logger.debug("I have reached the target")
      return transition(agent) 
    end
    
    if agent.senses_bump? && !@first_turn
      @logger.debug("I have hit an obstacle")
      return transition(agent)
    end
    
    unless @path
      @path = plot_path(agent)
      @logger.debug("I have plotted a path: #{@path.inspect} (remember this is a stack, so action order is reversed)")
    end
    
    raise Exception.new("Computed empty path from #{agent.location.inspect} to #{target.inspect}") if @path.nil? || @path.empty?
    
    @first_turn = false
    
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
    
#    puts "", "I'ma goin to #{target.inspect}"
    
    until fringe.empty?
#      puts "", "The fringe is: #{fringe.inspect}"
      fringe.sort!.reverse!
      n = fringe.pop
#      puts "Selecting #{n} for expansion"
      if n.finished?
#        puts "Target can be reached with: #{get_path_actions(n.path)} (remember this is a stack, so action order is reversed)" if n.finished?
        return get_path_actions(n.path) if n.finished?
      end
      visited << n
      n.successors.each {|s| fringe << s unless visited.include?(s)}
    end
    
    raise Exception.new("Could not compute path from #{location.inspect} to #{target.inspect}")
  end
  
  def get_path_actions(path)
    path.collect(&:action_taken).drop(1).reverse
  end
end
