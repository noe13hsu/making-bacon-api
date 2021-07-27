class Category < ApplicationRecord
  enum category_type: { Income: 0, Expense: 1 } #, _prefix: true
  
  belongs_to :user

  has_many :transactions, dependent: :destroy

  validates_presence_of :description, :category_type
end
