class BudgetRepresenter
    def initialize(budget)
        @budget = budget
    end

    def as_json
        {
            amount: budget.amount.to_f,
        }
    end

    private

    attr_reader :budget
end