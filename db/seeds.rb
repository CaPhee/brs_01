User.create!(
  name: "Triple Tee",
  email: "tien@framgia.com",
  address: "Earth",
  birthday: "1995/03/13",
  sex: "Male",
  password: "12312311",
  password_confirmation: "12312311",
  admin: true,
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
50.times do |n|
  name = "Category #{n}"
  Category.create! name: name
end
categorires = Category.first(5)
categorires.each do |category|
  50.times do |n|
    category.books.create title: "books #{n}",
      publish_date: Time.now, author: "Tee #{n+1}", number_of_pages: n*n,
      introduce: Faker::Lorem.sentence(70),
      rate: n % 5
  end
end
