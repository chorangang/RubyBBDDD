class UserData
    attr_accessor :id, :name, :email, :password, :created_at, :updated_at

    def initialize(id:, name:, email:, password:, created_at:, updated_at:)
        pp "===== user DTO ====="
        @id = id
        @name = name
        @email = email
        @password = password
        @created_at = created_at
        @updated_at = updated_at
    end

    def self.from_entity(user)
        # name,email,password値オブジェクトが持っている値を取り出す
        UserData.new(
            id:         user.id,
            name:       user.get_name_value,
            email:      user.get_email_value,
            password:   user.get_password_value,
            created_at: user.created_at,
            updated_at: user.updated_at
        )
    end

    def serialize_to_hash
        {
            id: @id,
            name: @name,
            email: @email,
            created_at: @created_at,
            updated_at: @updated_at,
        }
    end
end