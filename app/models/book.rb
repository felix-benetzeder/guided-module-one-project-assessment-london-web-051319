class Book < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews

  def reviewCount
    self.reviews.count
  end

  def averageRating
    self.reviews.average("rating")
  end

  def self.ignoreNil # This method rejects books without reviews
    Book.all.reject{|book| book.averageRating == nil}
  end

  def self.genreFilter(genre = nil)
    if genre
      ignoreNil.select {|book| book.genre == genre}
    else
      ignoreNil
    end
  end

  def self.averageRatingTotal(genre = nil)
    genreFilter(genre).map {|book| book.averageRating}
  end

  def self.bestBook (genre = nil)
    highestRating = averageRatingTotal(genre).max
    countOfRating = averageRatingTotal(genre).count(highestRating)
    genreFilter(genre).max_by(countOfRating) {|book| book.averageRating}
  end

  def self.worstBook (genre)
    lowestRating = averageRatingTotal(genre).min
    countOfRating = averageRatingTotal(genre).count(lowestRating)
    genreFilter(genre).min_by(countOfRating) {|book| book.averageRating}
  end

  def self.booksofAuthor(author)
    Book.all.select {|book| book.author == author}
  end

  def self.search_book_title(search_term)
    results = Book.all.where("lower(title) LIKE :search", search: "%#{search_term}%")
  end

  def self.search_for_author(search_term)
    results = Book.all.where("lower(author) LIKE :search", search "%#{search_term}%")
  end

  def self.lookForAuthor(author)
    booksofAuthor(author).each {|book| puts "The book #{book.title} has #{book.reviewCount} reviews and is rated with #{book.averageRating} on average."}
  end

  def self.lookForBook(title)
    book = Book.find_by_title(title)
    puts "The book #{book.title} written by #{book.author} has #{book.reviewCount} reviews and is rated with #{book.averageRating} on average."
  end

end
