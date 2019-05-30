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
      "NA"
    end
  end

  def print_stars(quantity)
    @quantity = quantity
    difference = @quantity.to_f - @quantity.to_i
    difference = difference.to_f.round(2)
    @quantity.to_i.times{ print "\u{2B50} "}
    if difference > 0 && difference <= 0.25
      fraction = "1/4"
      puts fraction
    elsif difference > 0.26 && difference <= 0.34
      fraction = "1/3"
      puts fraction
    elsif difference > 0.35 && difference <= 0.5
      fraction = "1/2"
      puts fraction
    elsif difference > 0.5 && difference <= 0.67
      fraction = "2/3"
      puts fraction
    elsif difference > 0.68 && difference <= 0.75
      fraction = "3/4"
      puts fraction
    end
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

  def self.worstBook (genre = nil)
    lowestRating = averageRatingTotal(genre).min
    countOfRating = averageRatingTotal(genre).count(lowestRating)
    genreFilter(genre).min_by(countOfRating) {|book| book.averageRating}
  end

  def self.search_book_title(search_term)
    results =  Book.all.where("lower(title) LIKE :search", search: "%#{search_term}%")
    if results.size >= 1
      results.each {|book| puts "The book #{book.title} written by #{book.author} has #{book.reviewCount} reviews and is rated with #{book.averageRating} on average."}
    else
      $prompt.error("That book does appear to exist here yet")
    end
  end

  def self.search_for_author(search_term)
    results = Book.all.where("lower(author) LIKE :search", search: "%#{search_term}%")
    if results.size >= 1
      results.each {|book| puts "The book #{book.title} written by #{book.author} has #{book.reviewCount} reviews and is rated with #{book.averageRating} on average."}
    else
      $prompt.error("There doesn't appear to be any books by #{search_term} here yet")
    end
  end

  def self.search_by_genre(genre)
    results = Book.all.where("lower(genre) LIKE :search", search: "%#{genre}%")
    if results.size >= 1
      results.each {|book| puts "The book #{book.title} written by #{book.author} has #{book.reviewCount} reviews and is rated with #{book.averageRating} on average."}
    else
      $prompt.error("There doesn't appear to be any books in that genre yet")
    end
  end

end
