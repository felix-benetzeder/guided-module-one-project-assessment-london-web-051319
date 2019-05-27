class CreateReview < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :description
      t.integer :rating
      t.integer :book_id
      t.integer :user_id
    end
  end
end
