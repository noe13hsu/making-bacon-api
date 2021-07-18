class Category < ApplicationRecord
  enum category_type: { income: 0, expense: 1 } #, _prefix: true
  
  belongs_to :user

  has_many :transactions, dependent: :destroy
end
