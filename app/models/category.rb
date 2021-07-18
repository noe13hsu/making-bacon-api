class Category < ApplicationRecord
  enum type: { income: 0, expense: 1 } #, _prefix: true
  
  belongs_to :user

  has_many :transactions, dependent: :destroy
end
