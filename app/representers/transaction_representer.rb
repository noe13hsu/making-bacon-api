class TransactionRepresenter
    def initialize(transaction)
        @transaction = transaction
    end

    def as_json
        {
            id: transaction.id,
            description: transaction.description,
            amount: transaction.amount,
            date: transaction.date,
            category: transaction.category.description,
            type: transaction.category.category_type
        }
    end

    private

    attr_reader :transaction
end