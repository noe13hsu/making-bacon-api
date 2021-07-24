module Api
    module V1
        class BudgetsController < ApplicationController
            before_action :authenticate
            before_action :current_user_budget, only: [:index, :update]

            def index
                budget = @budget

                render json: BudgetRepresenter.new(budget).as_json
            end

            def update
                budget = @budget
                if budget.update(budget_params)
                    render json: BudgetRepresenter.new(budget).as_json
                else
                    render json: { error: "Failed to update transaction" }, status: :unprocessable_entity
                end
            end

            private

            def current_user_budget
                @budget = Budget.find_by(user_id: @user_id)
            end

            def budget_params
                params.require(:budget).permit(:user_id, :amount)
            end
        end
    end
end
