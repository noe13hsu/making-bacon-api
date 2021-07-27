require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  before(:each) do
    @user = User.create!(name: "foo", email: "foo@gmail.com", password: "111111")

    @food = Category.create!(description: "food", category_type: "Expense", user_id: @user.id)
    @rental = Category.create!(description: "rental", category_type: "Income", user_id: @user.id)

    @pizza = Transaction.create!(description: "pizza", category_id: @food.id, amount: 10.5, date: "2021-05-23")
  end

  describe 'POST /user/transactions' do
    it 'creates a new expense transaction' do
      expect {
          post "/api/v1/user/transactions", 
            params: { transaction: {description: "bread", category_id: @food.id, amount: 3.5, date: "2021-06-23"} }, 
            headers: { 
              'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
            } 
      }.to change { transaction_category_type("Expense").count }.from(1).to(2)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "amount" => "3.5",
          "category" => "food",
          "date" => "2021-06-23",
          "description" => "bread",
          "id" => Transaction.last.id,
          "type" => "Expense"
        }
      )
    end

    it 'creates a new income transaction' do
      expect {
        post "/api/v1/user/transactions", 
          params: { transaction: {description: "rental income", category_id: @rental.id, amount: 300.0, date: "2021-06-23"} }, 
          headers: { 
            'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
          } 
      }.to change { transaction_category_type("Income").count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "amount" => "300.0",
          "category" => "rental",
          "date" => "2021-06-23",
          "description" => "rental income",
          "id" => Transaction.last.id,
          "type" => "Income"
        }
      )
    end
  end

  describe 'PUT /user/transactions/:id' do
    it 'updates a transaction description' do
      expect {
        put "/api/v1/user/transactions/#{@pizza.id}", 
          params: { transaction: {description: "kebab", category_id: @food.id, amount: 3.5, date: "2021-06-23"} }, 
          headers: { 
            'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
          } 
      }.to change { Transaction.find(@pizza.id).description }.from("pizza").to("kebab")

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { 
          "id" => @pizza.id,
          "amount" => "3.5",
          "category" => "food",
          "date" => "2021-06-23",
          "description" => "kebab",
          "type" => "Expense" 
        }
      )
    end

    it 'updates a transaction' do
      expect {
        put "/api/v1/user/transactions/#{@pizza.id}", 
          params: { transaction: {description: "pizza", category_id: @food.id, amount: 100.5, date: "2021-05-16"} }, 
          headers: { 
            'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
          } 
      }.to change { Transaction.find(@pizza.id).date }.from("2021-05-23".to_date).to("2021-05-16".to_date)

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { 
          "id" => @pizza.id,
          "amount" => "100.5",
          "category" => "food",
          "date" => "2021-05-16",
          "description" => "pizza",
          "type" => "Expense" 
        }
      )
    end
  end

  describe 'DELETE /user/transactions/:id' do
    it 'deletes a transaction' do
      expect {
        delete "/api/v1/user/transactions/#{@pizza.id}", 
        headers: { 
          'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
        } 
      }.to change { Transaction.where(id: @pizza.id).exists? }.from(true).to(false) 

      expect(response).to have_http_status(:no_content)
    end
  end
end
