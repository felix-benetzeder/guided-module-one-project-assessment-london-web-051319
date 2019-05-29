$prompt = TTY::Prompt.new
$caller = ""

def prewelcome
  $prompt.say("Welcome to Book Review!")
end

def welcome
  reply = $prompt.ask("Is this your first visit? (yes/no)")
  if reply == "yes"
    puts "Please register before using the database"
    registration
  elsif reply == "no"
    puts "Welcome back, please enter your username"
    login
  else
    puts "Please enter a valid answer"
    welcome
  end
end

def registration
  $prompt.collect do
    name = key(:name).ask('Name?')
    username = key(:username).ask('Username?')
    newUser = User.createUser(username: username, full_name: name)
    if newUser == "Error"
      welcome
    else
      $userobject = User.findUser(username)
      puts "Welcome #{username}"
      main_menu
    end
  end
end

def login
  username = $prompt.ask('What is your username?')
  indicator = User.logIn(username: username)
  if indicator == "Success"
    $userobject = User.findUser(username)
    puts "Welcome #{username}"
    main_menu
  else
    welcome
  end
end

def main_menu
  option = $prompt.select("What would you like to do today?", ["Submit review", "Read your reviews", "Edit Review","Delete Review", "Search for book",  "Search for an author", "Exit"])
    if option == "Submit review"
      $prompt.collect do
        title = key(:title).ask('Title of the book')
        description = key(:description).ask('What is your opinion?')
        rating = key(:rating).ask('Rating from 1 to 5')
        $userobject.createReview(description: description, rating: rating, book: title)
      end
      main_menu
      # rating = prompt.slider("Rating:", min: 1, max: 5, step: 0.5, symbols: {bullet:'⭐', line: '-'})
    elsif option == "Read your reviews"
      $userobject.showReviewContent
      main_menu
    elsif option == "Edit Review"
      $userobject.showReviewContent
      id = $prompt.ask("What is the ID of the review you want to change?")
      string = $prompt.ask("What is the new description you want to assign?")
      stars = $prompt.ask("What is the amended rating?") ### prompt.slider / 1-5?
      $userobject.editReview(id,string,stars)
      main_menu
    elsif option == "Delete Review"
      $userobject.showReviewContent
      id = $prompt.ask("What is the ID of the review you want to change?")
      $userobject.deleteReview(id)
      main_menu
    elsif option == "Search for book"
      search_term = $prompt.ask("What is the title of the book?")
      Book.search_book_title(search_term)
      main_menu
    elsif option == "Search for an author"
      search_term = $prompt.ask("What is the name of the author?")
      Book.search_for_author(search_term)
      main_menu
    elsif option == "Exit"
      puts "Goodbye #{$userobject.username}!"
    end
 end
