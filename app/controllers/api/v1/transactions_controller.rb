module Api
    module V1
        class TransactionsController < ApplicationController
            before_action :authenticate
            before_action :current_user_transaction_selection, only: [:show, :update, :destroy]

            def index
                # if User.find(params[:user_id])
                transactions = Transaction.select { |entry| entry.category.user_id == @user_id.to_i}
                sort_by_date = transactions.sort {|a, b| b.date - a.date}
                render json: TransactionsRepresenter.new(sort_by_date).as_json
                # else record_not_found
                # end
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
            def current_user_transaction_selection
                @transaction = Transaction.select { |entry| entry.category.user_id == @user_id }.find { |entry| entry.id == params[:id].to_i }
            end

            # def current_user_transaction_type(type)
            #     Transaction.select { |entry| entry.category.user_id == params[:user_id].to_i && entry.category.category_type == type }
            # end

            def transaction_params
                params.require(:transaction).permit(:category_id, :description, :amount, :date, :user_id, :id)
            end
        end
    end
end