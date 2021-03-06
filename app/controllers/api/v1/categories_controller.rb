module Api
    module V1
        class CategoriesController < ApplicationController
            before_action :authenticate
            before_action :current_user_category_selection, only: [:show, :update, :destroy]

            def index
                categories = Category.select { |entry| entry.user_id == @user_id.to_i}

                render json: CategoriesRepresenter.new(categories).as_json
            end

            def create
                category = Category.new(category_params.merge(user_id: @user_id))

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
                @category = Category.select { |entry| entry.user_id == @user_id.to_i }.find { |entry| entry.id == params[:id].to_i }
            end

            def category_params
                params.require(:category).permit(:description, :category_type, :id)
            end
        end
    end
end
