require 'rails_helper'

describe "Budgets API", type: :request do
  before(:all) do
    @user ||= User.create!(name: "foo",email: "foo@gmail.com", password: "111111")
  end
  # let!(:user) {FactoryBot.create(:user, name: "John", email: "john@gmail.com", password: "abc111")}

  describe 'GET /users/:user_id/budget' do
    it 'returns user budget' do
      get "/api/v1/users/#{@user.id}/budget"

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => @user.id, "amount" => "0.0" }
      )
    end
  end

  describe 'PUT /users/:user_id/budget' do
    it 'updates user budget' do
      expect {
        put "/api/v1/users/#{@user.id}/budget", params: { budget: {user_id: @user.id, amount: 1500} }
      }.to change { User.find(@user.id).budget.amount }.from(0).to(1500)

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "id" => @user.id, "amount" => "1500.0" }
      )
    end
  end
end
