class User < ActiveRecord::Base
  has_many :reviews
  has_many :books, through: :reviews

  def self.createUser(username:, full_name:)
    if User.all.map(&:username).include?(username)
      puts "This username is already taken - please select a different one"
      "Error"
    else
      User.create(username: username, full_name: full_name)
    end
  end

  def self.logIn(username:)
    if User.all.map(&:username).include?(username)
      puts "Login successful"
      "Success"
    else
      puts "This user does not exist, please enter a valid username"
    end
  end

  def self.findUser(username)
    User.find_by(username: username)
  end

  def showReviews
    self.reviews
  end

  def countReviews
    showReviews.count
  end

  def self.mostActiveUser
    self.all.max_by(&:countReviews)
  end

  def createReview(description:, rating:, book:)
    #get description rating and book from CLI
    bookID = Book.find_by_title(book).id
    Review.create(description: description, rating: rating, book_id: bookID, user_id: self.id, date: Date.today)
  end


  def reviewContent # Shows review with book title and information
    showReviews.map { |review| puts "#{review.book.title} - Your review was: #{review.description} and you rated the book with #{review.rating} stars."  }
  end

  def showReviewContent #puts it to console
    reviewContent.each { |content| puts content  }
  end

end
