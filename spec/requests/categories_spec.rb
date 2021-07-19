require 'rails_helper'

describe 'Categories API', type: :request do
  let!(:user) {FactoryBot.create(:user, name: "John", email: "john@gmail.com", password_digest: "abc111")}

  let!(:food) {FactoryBot.create(:category, description: "food", category_type: "expense", user_id: user.id)}
  let!(:transportation) {FactoryBot.create(:category, description: "transportation", category_type: "expense", user_id: user.id)}

  let!(:rental) {FactoryBot.create(:category, description: "rental", category_type: "income", user_id: user.id)}
  let!(:interest) {FactoryBot.create(:category, description: "interest", category_type: "income", user_id: user.id)}

  describe 'POST /categories' do
    it 'creates a new expense category' do
      expect {
          post '/api/v1/categories', params: { category: {description: "gifts", user_id: user.id, category_type: "expense"} }
      }.to change { category_type("expense").count }.from(2).to(3)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "id" => 5,
          "description" => "gifts",
          "type" => "expense"
        }
      )
    end

    it 'creates a new income category' do
      expect {
          post '/api/v1/categories', params: { category: {description: "employment", user_id: user.id, category_type: "income"} }
      }.to change { category_type("income").count }.from(2).to(3)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "id" => 10,
          "description" => "employment",
          "type" => "income"
        }
      )
    end
  end

  describe 'DELETE /categories/:id' do
    it 'deletes a category' do
      expect {
          delete "/api/v1/categories/#{food.id}"
      }.to change { Category.where(id: food.id).exists? }.from(true).to(false) 

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET /categories/:id' do
    it 'returns a category' do
      get "/api/v1/categories/#{transportation.id}"

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
          { "id" => transportation.id, "description" => "transportation", "type" => "expense" }
      )
    end
  end

  describe 'PUT /categories/:id' do
    it 'updates a category description' do
      expect {
          put "/api/v1/categories/#{food.id}", params: { category: {description: "drink", user_id: user.id, category_type: "expense"} }
      }.to change { Category.find(food.id).description }.from("food").to("drink")

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
          { "id" => food.id, "description" => "drink", "type" => "expense" }
      )
    end

    it 'updates a category type' do
      expect {
          put "/api/v1/categories/#{interest.id}", params: { category: {description: "interest", user_id: user.id, category_type: "expense"} }
      }.to change { Category.find(interest.id).category_type }.from("income").to("expense")

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
          { "id" => interest.id, "description" => "interest", "type" => "expense" }
      )
    end
  end
end