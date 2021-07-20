class BudgetRepresenter
    def initialize(budget)
        @budget = budget
    end

    def as_json
        {
            id: budget.id,
            amount: budget.amount,
        }
    end

    private

    attr_reader :budget
end