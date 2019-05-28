class User < ActiveRecord::Base
  has_many :reviews
  has_many :books, through: :reviews

  def self.createUser(username:, full_name:)
    if User.all.map(&:username).include?(username)
      "This username is already taken - please select a different one"
    else
      User.create(username: username, full_name: full_name)
    end
  end

  def self.login(username:)
    if User.all.map(&:username).include?(username)
      puts "Login successful"
    else
      puts "This user does not exist"
    end
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
    bookTitle = Book.find_by_title(book)
    Review.new(description: description, rating: rating, book_id: bookTitle, user_id: self.id, date: Date.today)
  end


  def reviewContent # Shows review with book title and information
    showReviews.map { |review| puts "#{review.book.title} - Your review was: #{review.description} and you rate the book with #{review.rating}."  }
  end

  def showReviewContent #puts it to console
    reviewContent.each { |content| puts content  }
  end

end
