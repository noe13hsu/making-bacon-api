module Api
    module V1
        class TransactionsController < ApplicationController
            before_action :set_transaction, only: [:show, :update, :destroy]

            rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

            def income
                income_transactions = Transaction.select { |entry| entry.category.category_type == "income" }

                render json: TransactionsRepresenter.new(income_transactions).as_json
            end

            def expense
                expense_transactions = Transaction.select { |entry| entry.category.category_type == "expense" }

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

            def set_transaction
                @transaction = Transaction.find(params[:id])
            end

            def transaction_params
                params.require(:transaction).permit(:category_id, :description, :amount, :date)
            end

            def record_not_found(e)
                render json: { error: e.message }, status: :not_found
            end
        end
    end
end