$prompt = TTY::Prompt.new

def prewelcome
  $prompt.say("Welcome to Book Review!")
end

def welcome
  reply = $prompt.ask("Is this your first visit? (yes/no)")
  if reply == "yes"
    puts "Please register before using the database"
    "registration"
  elsif reply == "no"
    puts "Welcome back, please enter your username"
    "login"
  else
    puts "Please enter a valid answer"
    "welcome"
  end
end

def registration
  name = $prompt.collect do
    key(:full_name).ask('Name?')
    key(:username).ask('Username?')
  end
  newUser = User.createUser(name)
  username = name[:username]
  if newUser == "Error"
    "welcome"
  else
    binding.pry
    $userobject = User.findUser(username)
    puts "Welcome #{username}"
    "main_menu"
  end
end

def login
  username = $prompt.ask('What is your username?')
  indicator = User.logIn(username: username)
  if indicator == "Success"
    $userobject = User.findUser(username)
    puts "Welcome #{username}"
    "main_menu"
  else
    "welcome"
  end
end

def main_menu
  option = $prompt.select("What would you like to do today?", ["Submit review", "Read your reviews", "Edit Review","Delete Review", "Search for book",  "Search for an author", "Exit"])
    if option == "Submit review"
      newReview = $prompt.collect do
        key(:title).ask('Title of the book')
        key(:description).ask('What is your opinion?')
        key(:rating).select("What is your rating (1-5)?", %w(1 2 3 4 5), convert: :int)
      end
      $userobject.createReview(newReview)
      "main_menu"
      elsif option == "Read your reviews"
      $userobject.showReviewContent
      "main_menu"
    elsif option == "Edit Review"
      $userobject.showReviewContent
      editedReview = $prompt.collect do
        key(:id).ask("What is the ID of the review you want to change?")
        key(:newDescription).ask("What is the new description you want to assign?")
        key(:newRating).select("What is the amended rating (1-5)?", %w(1 2 3 4 5), convert: :int)
      end
      $userobject.editReview(editedReview)
      "main_menu"
    elsif option == "Delete Review"
      $userobject.showReviewContent
      id = $prompt.ask("What is the ID of the review you want to change?")
      $userobject.deleteReview(id)
      "main_menu"
    elsif option == "Search for book"
      title = $prompt.ask("What is the title of the book?")
      Book.lookForBook(title)
      "main_menu"
    elsif option == "Search for an author"
      author = $prompt.ask("What is the name of the author?")
      Book.lookForAuthor(author)
      "main_menu"
    elsif option == "Exit"
      puts "Goodbye #{$userobject.username}!"
      "End"
    end
 end
