class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :category, null: false, foreign_key: true
      t.string :description, null: false
      t.decimal :amount, null: false, default: 0.0
      t.date :date, null: false

      t.timestamps
    end
  end
end
