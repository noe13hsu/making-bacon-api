class Budget < ApplicationRecord
  belongs_to :user

  validates_presence_of :amount
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
