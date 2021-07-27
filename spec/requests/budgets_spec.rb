require 'rails_helper'

describe "Budgets API", type: :request do
  before(:each) do
    @user = User.create!(name: "foo", email: "foo@gmail.com", password: "111111")
  end
  # let!(:user) {FactoryBot.create(:user, name: "John", email: "john@gmail.com", password: "abc111")}

  describe 'GET /user/budget' do
    it 'returns user budget' do
      get "/api/v1/user/budget", headers: { 
        'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
      } 

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "amount" => 0.0 }
      )
    end
  end

  describe 'PUT /user/budget' do
    it 'updates user budget' do
      expect {
        put "/api/v1/user/budget", 
          params: { budget: {user_id: @user.id, amount: 1500} }, 
          headers: { 
            'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
          } 
      }.to change { User.find(@user.id).budget.amount }.from(0).to(1500)

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        { "amount" => 1500.0 }
      )
    end
  end
end
