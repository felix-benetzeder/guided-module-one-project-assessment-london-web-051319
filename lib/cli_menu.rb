require "pry"


$prompt = TTY::Prompt.new

 def welcome
  $prompt.say("Welcome to Book Review!")
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
    User.createUser(username: username, full_name: name)
    $userobject = User.findUser(username)
    puts "Welcome #{username}"
    main_menu
  end
 end

 def login
  username = $prompt.ask('What is your username?')
  User.logIn(username: username)
  $userobject = User.findUser(username)
  puts "Welcome #{username}"
  main_menu
 end

 def main_menu
  option = $prompt.select("What would you like to do today?", ["Submit review", "Read your reviews", "Search for book",  "Search for an author", "Exit"])
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
    elsif option == "Search for book"
      title = $prompt.ask("What is the title of the book?")
      Book.lookForBook(title)
      main_menu
    elsif option == "Search for an author"
      author = $prompt.ask("What is the name of the author?")
      Book.lookForAuthor(author)
      main_menu
    elsif option == "Exit"
      puts "Goodbye #{$userobject.username}!"
      return
    end
 end
