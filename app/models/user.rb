class User < ActiveRecord::Base
  has_many :reviews
  has_many :books, through: :reviews

  def showReviews
    self.reviews
  end

  def countReviews
    showReviews.count
  end

  def self.mostActiveUser
    self.all.max_by(&:countReviews)
  end

  def self.findUser(username)
    User.find_by(username: username)
  end

  def reviewContent # Shows review with book title and information
    showReviews.map { |review| puts "ID: #{review.id} - #{review.book.title} - Your review was: #{review.description} and you rated the book with #{review.rating} stars."  }
  end

  def showReviewContent #puts it to console
    reviewContent.each { |content| puts content  }
  end

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

  def createReview(description:, rating:, title:)
    if Book.find_by_title(title) == nil
      puts "Please only select valid book titles or enter the book into the database"
    else
      bookID = Book.find_by_title(title).id
      Review.create(description: description, rating: rating, book_id: bookID, user_id: self.id, date: Date.today)
      puts "Added review, thanks for your contribution"
    end
  end

  def editReview(id:, newDescription:, newRating:)
    if Review.all.find_by(id: id) == nil || self.username != Review.all.find_by(id: id).user.username
      puts "Please only select valid ID numbers and reviews that you created yourself."
    else
      updatingReview = Review.all.find_by(id: id)
      updatingReview.update(description: newDescription, rating: newRating)
      puts "Successfully edited Review, please restart to see changes."
    end
  end

  def deleteReview(id)
    if Review.all.find_by(id: id) == nil || self.username != Review.all.find_by(id: id).user.username
      puts "Please only select valid ID numbers and reviews that you created yourself."
    else
      deletingReview = Review.all.find_by(id: id)
      deletingReview.destroy
      puts "Successfully, deleted review"
    end
  end

end
