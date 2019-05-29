require_relative '../config/environment.rb'

prewelcome
action = welcome

loop do
  action = send(action)
  break if action == "End"
end
