module Api
    module V1
        class CategoriesController < ApplicationController
            def income
                income_categories = Category.select { |entry| entry.category_type == "income" }

                render json: IncomeCategoriesRepresenter.new(income_categories).as_json
            end

            def create
                category = Category.new(category_params)

                if category.save
                    render json: CategoryRepresenter.new(category).as_json, status: :created
                else
                    render json: category.errors, status: :unprocessable_entity
                end
            end

            private

            def category_params
                params.require(:category).permit(:user_id, :description, :category_type)
            end
        end
    end
end
