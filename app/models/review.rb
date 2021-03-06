class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  def self.latestReviews #Shows reviews within the last 30 days
    Review.all.select {|review| (Date.today - review.date).to_i <= 30}
  end

  def self.display_book_info
  end

  def reviewsDisplayed
     "#{self.id}\nBook Name: #{self.book.title}\nAuthor Name: #{self.book.author}\nRating: #{self.rating}\nDescription: #{self.description}.\n_______________________________"
  end

end
