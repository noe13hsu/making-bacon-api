module Api
    module V1
        class CategoriesController < ApplicationController
            before_action :set_category, only: [:show, :update, :destroy]

            rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

            def income
                income_categories = Category.select { |entry| entry.category_type == "income" }

                render json: CategoriesRepresenter.new(income_categories).as_json
            end

            def expense
                expense_categories = Category.select { |entry| entry.category_type == "expense" }

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

            def set_category
                @category = Category.find(params[:id])
            end

            def category_params
                params.require(:category).permit(:user_id, :description, :category_type)
            end

            def record_not_found(e)
                render json: { error: e.message }, status: :not_found
            end
        end
    end
end
