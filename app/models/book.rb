class Book < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews

  def reviewCount
    self.reviews.count
  end

  def averageRating
    if reviews.count != 0
      (self.reviews.map(&:rating).sum.to_f / reviews.count).round(2)
    else
      "There is no review for this book available"
    end
  end

  def self.ignoreNil # This method rejects books without reviews
    Book.all.reject{|book| book.reviewCount == 0}
  end

  def self.genreFilter(genre = nil)
    if genre
      ignoreNil.select {|book| book.genre == genre}
    else
      ignoreNil
    end
  end

  def self.bestBook (genre)
    highestRating = genreFilter(genre).map {|book| book.averageRating}.max
    countOfRating = genreFilter(genre).map {|book| book.averageRating}.count(highestRating)
    genreFilter(genre).max_by(countOfRating) {|book| book.averageRating}
  end

  def self.worstBook (genre)
    lowestRating = genreFilter(genre).map {|book| book.averageRating}.min
    countOfRating = genreFilter(genre).map {|book| book.averageRating}.count(lowestRating)
    genreFilter(genre).min_by(countOfRating) {|book| book.averageRating}
  end

  def self.booksofAuthor(author)
    Book.all.select {|book| book.author == author}
  end

  # def self.bestAuthor #add optional genre
  #
  # end
  # ## Best Author with optional Genre
  #
  # def booksYouEnjoy(genre, author)
  #
  # end


end
