module RequestHelper
    def response_body
        JSON.parse(response.body)
    end

    def category_type(type)
        Category.select { |c| c.category_type == type }
    end
end