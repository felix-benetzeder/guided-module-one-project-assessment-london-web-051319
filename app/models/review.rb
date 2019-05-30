class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  def self.latestReviews #Shows reviews within the last 30 days
    Review.all.select {|review| (Date.today - review.date).to_i <= 30}
  end
  
end
