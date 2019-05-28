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

  def self.bestBook ## add an optional genre
    ignoreNil.max_by {|book| book.averageRating}
  end

  def self.worstBook ## add an optional genre
    ignoreNil.min_by {|book| book.averageRating}
  end

  def self.booksofAuthor(author)
    Book.all.select {|book| book.author == author}
  end

  ## Best Author with optional Genre

end
