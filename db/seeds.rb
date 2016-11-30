User.create!(
  name: "Tien",
  email: "tripletee.3t@gmail.com",
  address: "Earth",
  birthday: "1995/03/13",
  sex: "Male",
  password: "12312311",
  password_confirmation: "12312311",
  admin: true,
)
User.create!(
  name: "Quang Tien",
  email: "phanqtien@gmail.com",
  address: "Earth",
  birthday: "1995/03/13",
  sex: "Male",
  password: "12312311",
  password_confirmation: "12312311",
)
50.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@framgia.org"
  password = "123123"
  User.create!(
    name: name,
    email: email,
    address: "Galaxy",
    birthday: "1995/03/03",
    sex: "Male",
    password: password,
    password_confirmation: password,
  )
end
10.times do |n|
  name = "Category #{n}"
  Category.create! name: name
end
categorires = Category.first 5
categorires.each do |category|
  50.times do |n|
    category.books.create title: Faker::Book.title,
      publish_date: Time.now, author: Faker::Book.author,
      number_of_pages:Faker::Number.number(3),
      introduce: Faker::Lorem.paragraph(2), rate: 0
  end
end
10.times do |n|
  book = Book.new title: Faker::Book.title,
    publish_date: Time.now, author: Faker::Book.author,
    number_of_pages: Faker::Number.number(3),
    introduce: Faker::Lorem.paragraph(2), rate: 0, bought: false,
    category_id: Category.first.id
  if book.save
    Request.create book_id: book.id,user_id: rand(User.first.id..User.last.id),
      description: Faker::Lorem.paragraph(2)
  end
end

