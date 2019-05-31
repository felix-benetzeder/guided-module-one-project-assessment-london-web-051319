$prompt = TTY::Prompt.new

def prewelcome
  system "clear"
  $prompt.say("Welcome to Book Review!")
end

def welcome
  reply = $prompt.select("Do you already have an account?", %w(Login Register))
  if reply == "Register"
    puts "Please register before using the database"
    "registration"
  elsif reply == "Login"
    puts "Welcome back, please enter your username"
    "login"
  else
    $prompt.error("Please enter a valid answer")
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
    $userobject
    "main_menu"
  else
    "welcome"
  end
end

def main_menu
  option = $prompt.select("What would you like to do today?", ["Search","My Reviews", "Exit"])
    if option == "Search"
      "search_menu"
    elsif option == "My Reviews"
      "user_review_menu"
    elsif option == "Exit"
      puts "Goodbye #{$userobject.username}!"
      "End"
    end
  end

def search_menu
  system "clear"
  option = $prompt.select("How do you want to search?", ["Search for book", "Search for an author", "Search by genre", "Back to main menu"])
  if option == "Search for book"
    search_term = $prompt.ask("What is the title of the book?")
    results = Book.search_book_title(search_term)
    if results == "Error"
      $prompt.say("Would you like to add a book?")
      return "add_book"
    end
    $selected_book = $prompt.select("Please select a book to see or write reviews for", results.map(&:title))
    "selected_book_menu"
  elsif option == "Search for an author"
    search_term = $prompt.ask("What is the name of the author?")
    results = Book.search_for_author(search_term)
    if results == "Error"
      $prompt.say("Would you like to add a book written by this author?")
      return "add_book"
    end
    selected_author = $prompt.select("Please select an author", results.map(&:author).uniq)
    results = Book.all.select {|book| book.author == selected_author}
    $selected_book = $prompt.select("Please select a book to see or write reviews for", results.map(&:title))
    "selected_book_menu"
  elsif option == "Search by genre"
    search_term = $prompt.ask("What is the genre?")
    results = Book.search_by_genre(search_term)
    if results == "Error"
      $prompt.say("Would you like to add a book for that genre?")
      return "add_book"
    end
    selected_genre = $prompt.select("Please select a genre", results.map(&:genre).uniq)
    results = Book.all.select {|book| book.genre == selected_genre}
    $selected_book = $prompt.select("Please select a book to see or write reviews for", results.map(&:title))
    "selected_book_menu"
  elsif option == "Back to main menu"
    "main_menu"
  end
end

def add_book
  option = $prompt.select("Please select an option", ["Add book", "Back to main menu"])
  if option == "Add book"
    name = $prompt.collect do
      key(:title).ask('title?')
      key(:author).ask('author?')
      key(:genre).ask("genre?")
      key(:pages).ask("pages?")
    end
    User.createBook(name)
    "main_menu"
  elsif option == "Back to main menu"
    "main_menu"
  end
end

def selected_book_menu
  option = $prompt.select("What would you like to do?", ["Submit a review", "Read reviews", "Back to search menu"])
  if option == "Read reviews"
    Book.findByTitle($selected_book).showReviewContent
    "selected_book_menu"
  elsif option == "Submit a review"
    newReview = $prompt.collect do
      key(:description).ask('What is your opinion?')
      key(:rating).select("What is your rating (1-5)?", %w(1 2 3 4 5), convert: :int)
    end
    newReview[:title] = $selected_book
    $userobject.createReview(newReview)
    "selected_book_menu"
  elsif option == "Back to search menu"
    "search_menu"
  end
end

def user_review_menu
  option = $prompt.select("What would you like to do?", ["Read my reviews", "Edit a review", "Delete a review", "Back to main menu"])
  if option == "Read my reviews"
    review = $userobject.showReviewContent
    if review == []
      $prompt.error("You have no reviews yet")
      return "main_menu"
    end
    "main_menu"
  elsif option == "Edit a review"
    review = $userobject.showReviews
    if review == []
      $prompt.error("You have no reviews yet")
      return "main_menu"
    end
    response = $prompt.select("Which review would you like to edit?", review.map(&:reviewsDisplayed).push("Back"))
    if response == "Back"
      return "user_review_menu"
    end
    editedReview = $prompt.collect do
      key(:newDescription).ask("What is the new description you want to assign?")
      key(:newRating).select("What is the amended rating (1-5)?", %w(1 2 3 4 5), convert: :int)
    end
    editedReview[:id] = response.split("\n")[0].to_i
    $userobject.editReview(editedReview)
    "main_menu"
  elsif option == "Delete a review"
    review = $userobject.showReviews
    if review == []
      $prompt.error("You have no reviews yet")
      return "main_menu"
    end
    response = $prompt.select("Which review would you like to delete?", review.map(&:reviewsDisplayed).push("Back"))
    if response == "Back"
      return "user_review_menu"
    end
    $userobject.deleteReview(response.split("\n")[0].to_i)
    "main_menu"
  elsif option == "Back to main menu"
    "main_menu"
  end
end
