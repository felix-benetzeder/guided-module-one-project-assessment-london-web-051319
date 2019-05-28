require "pry"


$prompt = TTY::Prompt.new

 def welcome
  $prompt.say("Welcome to Book Review!")
  reply = $prompt.ask("Is this your first visit?")
  if reply == "yes"
    registration
  else
    login
  end
 end

 def registration
  $prompt.collect do 
    name = key(:name).ask('Name?')
    username = key(:username).ask('Username?')
  end
  # new_user = User.createUser(username: username, full_name: name)
  # puts "Welcome #{new_user.username}"
 end

 def login
  $prompt.ask('What is your username?')
 end

 def main_menu
  option = $prompt.select("What would you like to do today?", ["Submit review", "Read your reviews", "Search for book",  "Search for an author", "Exit"])
    if option == "Submit review"
      # create review method
      # rating = prompt.slider("Rating:", min: 1, max: 5, step: 0.5, symbols: {bullet:'⭐', line: '-'}) 
    elsif option == "Read your reviews"
      # user review method
    elsif option == "Search for book"
      # search for book
    elsif option == "Search for an author"
      # search for author
    elsif option == "Exit"
      puts "Goodbye!"
    end
 end

# "Find other books you may enjoy", "Edit a review"