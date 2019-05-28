prompt = TTY::Prompt.new

welcome = prompt.say("Welcome to Book Review!")

def get_user_name
  TTY::Prompt.new.ask('What is your name?')
end

get_user_name

menu_options = (["Submit review", "Find other books you may enjoy", "Read your reviews", "Edit a review"])
prompt.select("What would you like to do today?", menu_options)

rating = prompt.slider("Rating:", min: 1, max: 5, step: 0.5, symbols: {bullet:'⭐', line: "-"})
