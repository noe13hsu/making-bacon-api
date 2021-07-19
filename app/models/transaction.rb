class Transaction < ApplicationRecord
  belongs_to :category

  validates_presence_of :description, :amount, :date
end
