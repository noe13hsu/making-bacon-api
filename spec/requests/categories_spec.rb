require 'rails_helper'

describe 'Categories API', type: :request do
  before(:all) do
    @user ||= User.create!(name: "foo", email: "foo@gmail.com", password: "111111")

    @food ||= Category.create!(description: "food", category_type: "expense", user_id: @user.id)
    @transportation ||= Category.create!(description: "transportation", category_type: "expense", user_id: @user.id)

    @rental ||= Category.create!(description: "rental", category_type: "income", user_id: @user.id)
    @interest ||= Category.create!(description: "interest", category_type: "income", user_id: @user.id)
  end

  describe 'POST /users/:user_id/categories' do
    it 'creates a new expense category' do
      expect {
        post "/api/v1/users/#{@user.id}/categories", params: { category: {description: "gifts", user_id: @user.id, category_type: "expense"} }
      }.to change { category_type("expense").count }.from(2).to(3)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "id" => Category.last.id,
          "description" => "gifts",
          "type" => "expense"
        }
      )
    end

    it 'creates a new income category' do
      expect {
        post "/api/v1/users/#{@user.id}/categories", params: { category: {description: "employment", user_id: @user.id, category_type: "income"} }
      }.to change { category_type("income").count }.from(2).to(3)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "id" => Category.last.id,
          "description" => "employment",
          "type" => "income"
        }
      )
    end
  end

  describe 'DELETE /users/:user_id/categories/:id' do
    it 'deletes a category' do
      expect {
        delete "/api/v1/users/#{@user.id}/categories/#{@food.id}"
      }.to change { Category.where(id: @food.id).exists? }.from(true).to(false) 

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET /users/:user_id/categories/:id' do
    it 'returns a category' do
      get "/api/v1/users/#{@user.id}/categories/#{@transportation.id}"

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => @transportation.id, "description" => "transportation", "type" => "expense" }
      )
    end
  end

  describe 'GET /users/:user_id/expense_categories/' do
    it 'returns all expense categories' do
      get "/api/v1/users/#{@user.id}/expense_categories"

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        [
          {"description" => "food", "id" => @food.id, "type" => "expense"},
          {"description" => "transportation", "id" => @transportation.id, "type" => "expense"}
        ]
      )
    end
  end

  describe 'GET /users/:user_id/income_categories/' do
    it 'returns all income categories' do
      get "/api/v1/users/#{@user.id}/income_categories"

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        [
          {"description" => "rental", "id" => @rental.id, "type" => "income"},
          {"description" => "interest", "id" => @interest.id, "type" => "income"}
        ]
      )
    end
  end

  describe 'PUT /users/:user_id/categories/:id' do
    it 'updates a category description' do
      expect {
        put "/api/v1/users/#{@user.id}/categories/#{@food.id}", params: { category: {description: "drink", user_id: @user.id, category_type: "expense"} }
      }.to change { Category.find(@food.id).description }.from("food").to("drink")

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => @food.id, "description" => "drink", "type" => "expense" }
      )
    end

    it 'updates a category type' do
      expect {
        put "/api/v1/users/#{@user.id}/categories/#{@interest.id}", params: { category: {description: "interest", user_id: @user.id, category_type: "expense"} }
      }.to change { Category.find(@interest.id).category_type }.from("income").to("expense")

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => @interest.id, "description" => "interest", "type" => "expense" }
      )
    end
  end
end