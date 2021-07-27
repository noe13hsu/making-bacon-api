require 'rails_helper'

describe 'Categories API', type: :request do
  before(:each) do
    @user = User.create!(name: "foo", email: "foo@gmail.com", password: "111111")

    @food = Category.create!(description: "food", category_type: "Expense", user_id: @user.id)
    @transportation = Category.create!(description: "transportation", category_type: "Expense", user_id: @user.id)

    @rental = Category.create!(description: "rental", category_type: "Income", user_id: @user.id)
    @interest = Category.create!(description: "interest", category_type: "Income", user_id: @user.id)
  end

  describe 'POST /user/categories' do
    it 'creates a new expense category' do
      expect {
        post "/api/v1/user/categories", 
          params: { category: {description: "gifts", user_id: @user.id, category_type: "Expense"} }, 
          headers: { 
            'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
          } 
      }.to change { category_type("Expense").count }.from(2).to(3)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "id" => Category.last.id,
          "description" => "gifts",
          "type" => "Expense"
        }
      )
    end

    it 'creates a new income category' do
      expect {
        post "/api/v1/user/categories", 
          params: { category: {description: "employment", user_id: @user.id, category_type: "Income"} }, 
          headers: { 
            'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
          } 
      }.to change { category_type("Income").count }.from(2).to(3)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "id" => Category.last.id,
          "description" => "employment",
          "type" => "Income"
        }
      )
    end
  end

  describe 'DELETE /user/categories/:id' do
    it 'deletes a category' do
      expect {
        delete "/api/v1/user/categories/#{@food.id}", 
        headers: { 
          'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
        } 
      }.to change { Category.where(id: @food.id).exists? }.from(true).to(false) 

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PUT /user/categories/:id' do
    it 'updates a category description' do
      expect {
        put "/api/v1/user/categories/#{@food.id}", 
          params: { category: {description: "drink", user_id: @user.id, category_type: "Expense"} }, 
          headers: { 
            'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
          } 
      }.to change { Category.find(@food.id).description }.from("food").to("drink")

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => @food.id, "description" => "drink", "type" => "Expense" }
      )
    end

    it 'updates a category type' do
      expect {
        put "/api/v1/user/categories/#{@interest.id}", 
          params: { category: {description: "interest", user_id: @user.id, category_type: "Expense"} }, 
          headers: { 
            'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
          } 
      }.to change { Category.find(@interest.id).category_type }.from("Income").to("Expense")

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => @interest.id, "description" => "interest", "type" => "Expense" }
      )
    end
  end
end