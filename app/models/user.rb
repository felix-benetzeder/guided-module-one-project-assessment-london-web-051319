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

  def showReviews
    self.reviews
  end

  def countReviews
    showReviews.count
  end

  def self.mostActiveUser
    self.all.max_by(&:countReviews)
  end

  ## Create Review
  ## Edit review - only if self.id == user.id

end
