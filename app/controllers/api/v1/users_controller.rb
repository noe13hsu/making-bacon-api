module Api
    module V1
        class UsersController < ApplicationController
            class AuthenticationError < StandardError; end

            rescue_from ActionController::ParameterMissing, with: :parameter_missing
            rescue_from AuthenticationError, with: :handle_unauthenticated

            before_action :current_user, only: [:show, :update, :destroy]

            def login
                raise AuthenticationError unless user.authenticate(params.require(:password))
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
                    render json: UserRepresenter.new(user).as_json, status: :created
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

            def destroy
                @user.destroy!

                head :no_content
            end

            private

            def user
                @user ||= User.find_by_email(params.require(:email))
            end

            def current_user
                @user = User.find(params[:user_id])
            end

            def user_params
                params.permit(:name, :email, :password)
            end

            def update_user_params
                params.permit(:name, :password)
            end

            def handle_unauthenticated
                head :unauthorized
            end

            def parameter_missing
                render json: { error: "Param is missing or the value is empty" }, status: :unprocessable_entity
            end
        end
    end
end