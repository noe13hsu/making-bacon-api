class UserRepresenter
    def initialize(user)
        @user = user
    end

    def as_json
        {
            name: user.name
        }
    end

    private

    attr_reader :user
end