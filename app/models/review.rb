class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  ## Reviews of the last 14 days
end
