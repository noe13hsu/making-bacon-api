class ApplicationController < ActionController::API
    rescue_from NoMethodError, with: :record_not_found
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    private

    def record_not_found
        render json: { error: "Record not found" }, status: :not_found
    end

    def authenticate
        begin
            token = request.headers["Authorization"].split(' ')[1]
            payload = JWT.decode(token, 'my$ecretK3y', true, { algorithm: 'HS256'})[0]
            @user_id = payload["user_id"]
        rescue
            render json: { error: "Invalid token" }, status: :unauthorized
        end
    end
end
