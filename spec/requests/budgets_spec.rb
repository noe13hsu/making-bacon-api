require 'rails_helper'

describe "Budgets API", type: :request do
  let!(:user) {FactoryBot.create(:user, name: "John", email: "john@gmail.com", password_digest: "abc111")}

  let!(:budget) {FactoryBot.create(:budget, user_id: user.id, amount: 1000)}

  describe 'GET /user/:user_id/budget' do
    it 'returns user budget' do
      get "/api/v1/user/#{user.id}/budget"

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => budget.id, "amount" => "1000.0" }
      )
    end
  end

  describe 'PUT /user/:user_id/budget' do
    it 'updates user budget' do
      expect {
      put "/api/v1/user/#{user.id}/budget", params: { budget: {user_id: user.id, amount: 1500} }
    }.to change { User.find(user.id).budget.amount }.from(1000).to(1500)

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => budget.id, "amount" => "1500.0" }
      )
    end
  end
end
