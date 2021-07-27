module Api
    module V1
        class UsersController < ApplicationController
            class AuthenticationError < StandardError; end

            rescue_from ActionController::ParameterMissing, with: :parameter_missing
            rescue_from NoMethodError, with: :handle_unauthenticated
            rescue_from AuthenticationError, with: :handle_unauthenticated

            before_action :authenticate, except: [:login, :create]
            before_action :current_user, only: [:show, :update, :destroy]

            def login
                raise AuthenticationError unless user.authenticate(user_params[:password])
                token = AuthenticationTokenService.call(user.id)

                render json: { token: token }, status: :created 
            end

            def show
                user = @user

                render json: UserRepresenter.new(user).as_json
            end

            def create
                user = User.new(user_params)

                if user.save
                    new_user = User.find_by(email: user.email)
                    token = AuthenticationTokenService.call(new_user.id)
                    render json: { token: token }, status: :created 
                else
                    render json: { error: "Failed to create user" }, status: :unprocessable_entity
                end
            end

            def update
                user = @user
                if user.update(update_user_params)
                    render json: UserRepresenter.new(user).as_json
                else
                    render json: { error: "Failed to update user" }, status: :unprocessable_entity
                end
            end

            private

            def user
                @user ||= User.find_by_email(user_params[:email])
            end

            def current_user
                @user = User.find(@user_id)
            end

            def user_params
                params.permit(:name, :email, :password)
            end

            def update_user_params
                params.permit(:name, :password)
            end

            def handle_unauthenticated
                render json: { error: 'Username or password incorrect' }, status: :unprocessable_entity
            end

            def parameter_missing
                render json: { error: "Param is missing or the value is empty" }, status: :unprocessable_entity
            end
        end
    end
end