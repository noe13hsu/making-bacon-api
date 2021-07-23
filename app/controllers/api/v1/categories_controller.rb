module Api
    module V1
        class CategoriesController < ApplicationController
            # before_action :authenticate
            before_action :current_user_category_selection, only: [:show, :update, :destroy]

            def index
                categories = Category.select { |entry| entry.user_id == params[:user_id].to_i}

                render json: CategoriesRepresenter.new(categories).as_json
            end

            def income
                income_categories = current_user_category_type("income")

                render json: CategoriesRepresenter.new(income_categories).as_json
            end

            def expense
                expense_categories = current_user_category_type("expense")

                render json: CategoriesRepresenter.new(expense_categories).as_json
            end

            def show
                category = @category

                render json: CategoryRepresenter.new(category).as_json
            end

            def create
                category = Category.new(category_params)

                if category.save
                    render json: CategoryRepresenter.new(category).as_json, status: :created
                else
                    render json: { error: "Failed to create category" }, status: :unprocessable_entity
                end
            end

            def update
                category = @category
                if category.update(category_params)
                    render json: CategoryRepresenter.new(category).as_json
                else
                    render json: { error: "Failed to update category" }, status: :unprocessable_entity
                end
            end

            def destroy
                @category.destroy!

                head :no_content
            end

            private

            def current_user_category_selection
                @category = Category.select { |entry| entry.user_id == params[:user_id].to_i }.find { |entry| entry.id == params[:id].to_i }
            end

            def current_user_category_type(type)
                Category.select { |entry| entry.user_id == params[:user_id].to_i && entry.category_type == type }
            end

            def category_params
                params.require(:category).permit(:user_id, :description, :category_type, :id)
            end
        end
    end
end
