class CreateBudgets < ActiveRecord::Migration[6.1]
  def change
    create_table :budgets do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, null: false, default: 0.0

      t.timestamps
    end
  end
end
