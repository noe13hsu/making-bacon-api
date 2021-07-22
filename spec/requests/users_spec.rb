require 'rails_helper'

describe "Users API", type: :request do
    before(:all) do
        @user ||= User.create!(name: "foo",email: "foo@gmail.com", password: "111111")
    end

    describe 'GET /users/:user_id' do
        it 'returns a user' do
            get "/api/v1/users/#{@user.id}"

            expect(response).to have_http_status(:success)
            expect(response_body).to eq(
                { "id" => @user.id, "name" => "foo", "email" => "foo@gmail.com" }
            )
        end
    end

    describe 'PUT /users/:user_id' do
        it 'updates a user' do
            expect {
                put "/api/v1/users/#{@user.id}", params: { id: @user.id, name: "J0hn", email: "foo@gmail.com", password: "111111"}
            }.to change { User.find(@user.id).name }.from("foo").to("J0hn")

            expect(response).to have_http_status(:success)
            expect(response_body).to eq(
                { "id" => @user.id, "name" => "J0hn", "email" => "foo@gmail.com" }
            )
        end

        it 'does not update user email' do
            expect {
                put "/api/v1/users/#{@user.id}", params: { user: {id: @user.id, name: "John", "email" => "john@gmail.com", password: "abc111"} }
            }.not_to change { User.find(@user.id).email }

            expect(response).to have_http_status(:success)
            expect(response_body).to eq(
                { "id" => @user.id, "name" => "foo", "email" => "foo@gmail.com" }
            )
        end
    end

    describe 'POST /api/v1/register' do
        it 'creates a new user' do
            post '/api/v1/register', params: { name: "bar", email: "bar@gmail.com", password: "111111"}

            expect(response).to have_http_status(:created)
            expect(response_body).to eq({
                "email" => "bar@gmail.com",
                "id" => User.last.id,
                "name" => "bar"
            })
        end
    end

    describe 'POST /api/v1/login' do
        it 'authenticates a user' do
            post '/api/v1/login', params: { email: "foo@gmail.com", password: "111111" }

            expect(response).to have_http_status(:created)
            expect(response_body).to eq({
                "token" => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
            })
        end

        it 'returns an error if email is missing' do
            post '/api/v1/login', params: { password: "111111" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                "error" => "Param is missing or the value is empty"
            })
        end

        it 'return an error if password is missing' do
            post '/api/v1/login', params: { email: "foo@gmail.com" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                "error" => "Param is missing or the value is empty"
            })
        end

        it 'returns error when password is incorrect' do
            post '/api/v1/login', params: { email: "foo@gmail.com", password: "incorrect" }

            expect(response).to have_http_status(:unauthorized) # no response body so hackers wont know whether it is username or password that is incorrect
        end
    end
end
