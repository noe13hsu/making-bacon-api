class CategoryRepresenter
    def initialize(category)
        @category = category
    end

    def as_json
        {
            id: category.id,
            description: category.description,
            type: category.category_type,
        }
    end

    private

    attr_reader :category
end