class User < ApplicationRecord
    has_secure_password

    has_many :categories, dependent: :destroy
    has_one :budget, dependent: :destroy

    validates_presence_of :name, :email, :password_digest
end
