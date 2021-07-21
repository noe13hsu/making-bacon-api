require 'rails_helper'

describe "Users API", type: :request do
    let!(:user) {FactoryBot.create(:user, name: "John", email: "john@gmail.com", password: "abc111")}

    describe 'GET /users/:user_id' do
        it 'returns a user' do
            get "/api/v1/users/#{user.id}"

            expect(response).to have_http_status(:success)
            expect(response_body).to eq(
                { "id" => user.id, "name" => "John", "email" => "john@gmail.com" }
            )
        end
    end

    describe 'PUT /users/:user_id' do
        it 'updates a user' do
            expect {
                put "/api/v1/users/#{user.id}", params: { user: {id: user.id, name: "J0hn", email: "john@gmail.com", password: "abc111"} }
            }.to change { User.find(user.id).name }.from("John").to("J0hn")

            expect(response).to have_http_status(:success)
            expect(response_body).to eq(
                { "id" => user.id, "name" => "J0hn", "email" => "john@gmail.com" }
            )
        end

        it 'does not update user email' do
            expect {
                put "/api/v1/users/#{user.id}", params: { user: {id: user.id, name: "John", email: "new.john@gmail.com", password_digest: "abc111"} }
            }.not_to change { User.find(user.id).email }

            expect(response).to have_http_status(:success)
            expect(response_body).to eq(
                { "id" => user.id, "name" => "John", "email" => "john@gmail.com" }
            )
        end
    end

    describe 'POST /api/v1/login' do
        it 'authenticates a user' do
            post '/api/v1/login', params: { email: "john@gmail.com", password: "abc111" }

            expect(response).to have_http_status(:created)
            expect(response_body).to eq({
                "token" => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMn0.KeU97sLvyxRyWuGTGajwHze9QOPu6mfBcz7fpZb3SM0"
            })
        end

        it 'returns an error if email is missing' do
            post '/api/v1/login', params: { password: "abc111" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                "error" => "Param is missing or the value is empty"
            })
        end

        it 'return an error if password is missing' do
            post '/api/v1/login', params: { email: "john@gmail.com" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                "error" => "Param is missing or the value is empty"
            })
        end

        it 'returns error when password is incorrect' do
            post '/api/v1/login', params: { email: "john@gmail.com", password: "incorrect" }

            expect(response).to have_http_status(:unauthorized) # no response body so hackers wont know whether it is username or password that is incorrect
        end
    end
end
