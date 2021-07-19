FactoryBot.define do
  factory :transaction do
    category { nil }
    description { "MyString" }
    amount { "9.99" }
    date { "2021-07-18" }
  end
end
