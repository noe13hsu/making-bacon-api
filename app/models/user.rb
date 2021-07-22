class User < ApplicationRecord
    has_secure_password

    has_many :categories, dependent: :destroy
    has_one :budget, dependent: :destroy

    validates_presence_of :name, :email, :password_digest
    validates :email, uniqueness: true

    after_create :create_budget

    def create_budget
        Budget.create!(user_id: self.id, amount: 0.0)
    end

    # def as_json
    #     {
    #         id: self.id,
    #         description: self.description,
    #         type: self.category_type,
    #     }
    # end

    # a = user.first
    # render :json: a.as_json
end
