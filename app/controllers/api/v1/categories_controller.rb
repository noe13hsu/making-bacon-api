module Api
    module V1
        class CategoriesController < ApplicationController
           def income
           income_categories = Category.select { |entry| entry.category_type == "income" }

           render json: IncomeCategoriesRepresenter.new(income_categories).as_json
           end
        
        end
    end
end
