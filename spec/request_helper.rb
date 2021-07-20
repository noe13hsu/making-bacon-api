module RequestHelper
    def response_body
        JSON.parse(response.body)
    end

    def category_type(type)
        Category.select { |c| c.category_type == type }
    end

    def transaction_category_type(type)
        Transaction.select { |t| t.category.category_type == type }
    end
end