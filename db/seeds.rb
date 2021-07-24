# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all

noe = User.create!(name: "Noe", email: "noe@gmail.com", password: "111111")
kate = User.create!(name: "Kate", email: "test@tester.com", password: "123456")

category_food = Category.create!(user_id: noe.id, description: "food", category_type: 1)
category_gifts = Category.create!(user_id: noe.id, description: "gifts", category_type: 1)
category_transportation = Category.create!(user_id: noe.id, description: "transportation", category_type: 1)

category_food_kate = Category.create!(user_id: kate.id, description: "food", category_type: 1)
category_gifts_kate = Category.create!(user_id: kate.id, description: "gifts", category_type: 1)
category_transportation_kate = Category.create!(user_id: kate.id, description: "transportation2", category_type: 1)

category_employment = Category.create!(user_id: noe.id, description: "employment", category_type: 0)
category_investment = Category.create!(user_id: noe.id, description: "investment", category_type: 0)

category_employment_kate = Category.create!(user_id: kate.id, description: "employment", category_type: 0)
category_investment_kate = Category.create!(user_id: kate.id, description: "investment", category_type: 0)

Transaction.create!(category_id: category_food.id, description: "food", amount: "4.5", date: "2021-07-06")
Transaction.create!(category_id: category_food.id, description: "milk", amount: "3.5", date: "2021-07-06")
Transaction.create!(category_id: category_food.id, description: "pizza", amount: "10.5", date: "2021-07-13")

Transaction.create!(category_id: category_gifts.id, description: "flower", amount: "20", date: "2021-07-21")

Transaction.create!(category_id: category_transportation.id, description: "train", amount: "4.5", date: "2021-07-02")
Transaction.create!(category_id: category_transportation.id, description: "train", amount: "4.5", date: "2021-07-02")

Transaction.create!(category_id: category_employment.id, description: "june 2021", amount: "1040", date: "2021-06-02")
Transaction.create!(category_id: category_employment.id, description: "july 2021", amount: "1040", date: "2021-07-02")
Transaction.create!(category_id: category_investment.id, description: "property A june 2021", amount: "140", date: "2021-06-21")

Transaction.create!(category_id: category_food_kate.id, description: "food", amount: "4.5", date: "2021-07-06")
Transaction.create!(category_id: category_food_kate.id, description: "milk", amount: "3.5", date: "2021-07-06")
Transaction.create!(category_id: category_food_kate.id, description: "pizza", amount: "10.5", date: "2021-07-13")

Transaction.create!(category_id: category_gifts_kate.id, description: "flower", amount: "20", date: "2021-07-21")

Transaction.create!(category_id: category_transportation_kate.id, description: "train", amount: "4.5", date: "2021-07-02")
Transaction.create!(category_id: category_transportation_kate.id, description: "train", amount: "4.5", date: "2021-07-02")

Transaction.create!(category_id: category_employment_kate.id, description: "june 2021", amount: "1040", date: "2021-06-02")
Transaction.create!(category_id: category_employment_kate.id, description: "july 2021", amount: "1040", date: "2021-07-02")
Transaction.create!(category_id: category_investment_kate.id, description: "potato bank june 2021", amount: "140", date: "2021-06-21")

