def generate_data
  for x in 1..20
    User.create(name: Faker::Name.name)
    Book.create(title: Faker::Book.title, author: Faker::Book.author, genre: Faker::Book.genre, pages: rand(50..350))
  end
  for x in 1..40
    Review.create(description: Faker::Quote.famous_last_words, rating: rand(1..5), book_id:rand(1..20), user_id: rand(1..20))
  end
end
