module Api
    module V1
        class BudgetsController < ApplicationController
            before_action :set_budget, only: [:show, :update]

            def show
                def show
                    budget = @budget
    
                    render json: BudgetRepresenter.new(budget).as_json
                end
            end

            def update
                if @budget.update(budget_params)
                    render json: { budget: @budget }
                else
                    render json: { error: "Failed to update transaction" }, status: :unprocessable_entity
                end
            end

            private

            def set_budget
                @budget = Budget.find_by(user_id: params[:user_id])
            end

            def budget_params
                params.require(:budget).permit(:user_id, :amount)
            end
        end
    end
end
