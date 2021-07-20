require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let!(:user) {FactoryBot.create(:user, name: "John", email: "john@gmail.com", password_digest: "abc111")}

  let!(:food) {FactoryBot.create(:category, description: "food", category_type: "expense", user_id: user.id)}
  let!(:rental) {FactoryBot.create(:category, description: "rental", category_type: "income", user_id: user.id)}

  let!(:pizza) {FactoryBot.create(:transaction, description: "pizza", category_id: food.id, amount: 10.5, date: "2021-05-23")}

  describe 'POST /transactions' do
    it 'creates a new expense transaction' do
      expect {
          post '/api/v1/user/transactions', params: { transaction: {description: "bread", category_id: food.id, amount: 3.5, date: "2021-06-23"} }
      }.to change { transaction_category_type("expense").count }.from(1).to(2)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "amount" => "3.5",
          "category" => "food",
          "date" => "2021-06-23",
          "description" => "bread",
          "id" => 2,
          "type" => "expense"
        }
      )
    end

    it 'creates a new income transaction' do
      expect {
          post '/api/v1/user/transactions', params: { transaction: {description: "rental income", category_id: rental.id, amount: 300.0, date: "2021-06-23"} }
      }.to change { transaction_category_type("income").count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "amount" => "300.0",
          "category" => "rental",
          "date" => "2021-06-23",
          "description" => "rental income",
          "id" => 4,
          "type" => "income"
        }
      )
    end
  end

  describe 'GET /transactions/:id' do
    it 'returns a transaction' do
      get "/api/v1/user/transactions/#{pizza.id}"

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
          { 
            "id" => pizza.id, 
            "description" => "pizza", 
            "amount" => "10.5",
            "category" => "food",
            "date" => "2021-05-23",
            "type" => "expense"
          }
      )
    end
  end

  describe 'GET /expense_transactions/' do
    it 'returns all expense transactions' do
      get "/api/v1/user/expense_transactions"

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        [
          {
            "amount"=>"10.5", 
            "category"=>"food", 
            "date"=>"2021-05-23", 
            "description"=>"pizza", 
            "id"=>6, 
            "type"=>"expense"}
        ]
      )
    end
  end

  describe 'PUT /transactions/:id' do
    it 'updates a transaction description' do
      expect {
          put "/api/v1/user/transactions/#{pizza.id}", params: { transaction: {description: "kebab", category_id: food.id, amount: 3.5, date: "2021-06-23"} }
      }.to change { Transaction.find(pizza.id).description }.from("pizza").to("kebab")

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
          { 
            "id" => pizza.id,
            "amount" => "3.5",
            "category" => "food",
            "date" => "2021-06-23",
            "description" => "kebab",
            "type" => "expense" 
          }
      )
    end

    it 'updates a transaction amount' do
      expect {
          put "/api/v1/user/transactions/#{pizza.id}", params: { transaction: {description: "pizza", category_id: food.id, amount: 4.5, date: "2021-06-23"} }
      }.to change { Transaction.find(pizza.id).amount }.from((10.5).to_d).to(4.5)

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
          { 
            "id" => pizza.id,
            "amount" => "4.5",
            "category" => "food",
            "date" => "2021-06-23",
            "description" => "pizza",
            "type" => "expense" 
          }
      )
    end

    it 'updates a transaction date' do
      expect {
          put "/api/v1/user/transactions/#{pizza.id}", params: { transaction: {description: "pizza", category_id: food.id, amount: 10.5, date: "2021-05-16"} }
      }.to change { Transaction.find(pizza.id).date }.from("2021-05-23".to_date).to("2021-05-16".to_date)

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
          { 
            "id" => pizza.id,
            "amount" => "10.5",
            "category" => "food",
            "date" => "2021-05-16",
            "description" => "pizza",
            "type" => "expense" 
          }
      )
    end
  end

  describe 'DELETE /transactions/:id' do
    it 'deletes a transaction' do
      expect {
          delete "/api/v1/user/transactions/#{pizza.id}"
      }.to change { Transaction.where(id: pizza.id).exists? }.from(true).to(false) 

      expect(response).to have_http_status(:no_content)
    end
  end

  
end
