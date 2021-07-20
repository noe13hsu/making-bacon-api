require 'rails_helper'

RSpec.describe "Budgets", type: :request do
  let!(:user) {FactoryBot.create(:user, name: "John", email: "john@gmail.com", password_digest: "abc111")}

  let!(:budget) {FactoryBot.create(:budget, user_id: user.id, amount: 1000)}

  describe 'GET /user/:user_id/budget' do
    it 'returns user budget'
      
end
