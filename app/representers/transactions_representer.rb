class TransactionsRepresenter
    def initialize(transactions)
        @transactions = transactions
    end

    def as_json
        transactions.map do |transaction|
            {
                id: transaction.id,
                description: transaction.description,
                amount: transaction.amount,
                date: transaction.date,
                category: transaction.category.description,
                type: transaction.category.category_type
            }
        end
    end

    private

    attr_reader :transactions
end