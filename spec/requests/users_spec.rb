require 'rails_helper'

describe "Users API", type: :request do
    before(:each) do
        @user = User.create!(name: "foo", email: "foo@gmail.com", password: "111111")
    end

    describe 'GET /user/me' do
        it 'returns a user' do
            get "/api/v1/user/me", headers: { 
                'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
            } 
             

            expect(response).to have_http_status(:success)
            expect(response_body).to eq(
                { "name" => "foo" }
            )
        end
    end

    describe 'PUT /user/me' do
        it 'updates a user' do
            expect {
                put "/api/v1/user/me", 
                    params: { name: "J0hn" }, 
                    headers: { 
                        'Authorization': "Bearer #{AuthenticationTokenService.call(@user.id)}"
                    } 
            }.to change { User.find(@user.id).name }.from("foo").to("J0hn")

            expect(response).to have_http_status(:success)
            expect(response_body).to eq(
                { "name" => "J0hn" }
            )
        end
    end

    describe 'POST /api/v1/register' do
        it 'creates a new user' do
            post '/api/v1/register', params: { name: "bar", email: "bar@gmail.com", password: "111111"}

            expect(response).to have_http_status(:created)
            expect(response_body).to eq({
                "token" => AuthenticationTokenService.call(User.last.id)
            })
        end
    end

    describe 'POST /api/v1/login' do
        it 'authenticates the user' do
            post '/api/v1/login', params: { email: 'foo@gmail.com', password: '111111' }
            expect(response).to have_http_status(:created)
            expect(response_body).to eq({
              'token' => AuthenticationTokenService.call(@user.id)
              })
        end

        it 'returns an error if email is missing' do
            post '/api/v1/login', params: { password: "111111" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                "error" => "Username or password incorrect"
            })
        end

        it 'return an error if password is missing' do
            post '/api/v1/login', params: { email: "foo@gmail.com" }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                "error" => "Username or password incorrect"
            })
        end

        it 'returns error when password is incorrect' do
            post '/api/v1/login', params: { email: "foo@gmail.com", password: "incorrect" }

            expect(response).to have_http_status(:unprocessable_entity) # no response body so hackers wont know whether it is username or password that is incorrect
            expect(response_body).to eq({
                "error" => "Username or password incorrect"
            })
        end
    end
end
