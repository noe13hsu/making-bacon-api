class ApplicationController < ActionController::API
    rescue_from NoMethodError, with: :record_not_found
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    private

    def record_not_found
        render json: { error: "Unprocessable request" }, status: :not_found
    end
end
