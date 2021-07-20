module Api
    module V1
        class TransactionsController < ApplicationController
            before_action :current_user_transactions, only: [:show, :update, :destroy]

            rescue_from NoMethodError, with: :record_not_found

            def index
                transactions = Transaction.select { |entry| entry.category.user_id == params[:user_id].to_i}

                render json: TransactionsRepresenter.new(transactions).as_json
            end

            def income
                income_transactions = current_user_transaction_type("income")

                render json: TransactionsRepresenter.new(income_transactions).as_json
            end

            def expense
                expense_transactions = current_user_transaction_type("expense")

                render json: TransactionsRepresenter.new(expense_transactions).as_json
            end

            def show
                transaction = @transaction

                render json: TransactionRepresenter.new(transaction).as_json
            end

            def create
                transaction = Transaction.new(transaction_params)

                if transaction.save
                    render json: TransactionRepresenter.new(transaction).as_json, status: :created
                else
                    render json: { error: "Failed to create transaction" }, status: :unprocessable_entity
                end
            end

            def update
                transaction = @transaction
                if transaction.update(transaction_params)
                    render json: TransactionRepresenter.new(transaction).as_json
                else
                    render json: { error: "Failed to update transaction" }, status: :unprocessable_entity
                end
            end

            def destroy
                @transaction.destroy!

                head :no_content
            end

            private
            def current_user_transactions
                @transaction = Transaction.select { |entry| entry.category.user_id == params[:user_id].to_i }.find { |entry| entry.id == params[:id].to_i }
            end

            def current_user_transaction_type(type)
                Transaction.select { |entry| entry.category.user_id == params[:user_id].to_i && entry.category.category_type == type }
            end

            def transaction_params
                params.require(:transaction).permit(:category_id, :description, :amount, :date, :user_id, :id)
            end

            def record_not_found
                render json: { error: "Unprocessable request" }, status: :unprocessable_entity
            end
        end
    end
end