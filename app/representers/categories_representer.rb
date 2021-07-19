class CategoriesRepresenter
    def initialize(categories)
        @categories = categories
    end

    def as_json
        categories.map do |category|
            {
                id: category.id,
                description: category.description,
                type: category.category_type,
            }
        end
    end

    private

    attr_reader :categories
end