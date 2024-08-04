require './src/domain/models/user'

class AuthService
    def register(request_hash)
        @user = User.new(request_hash)
        result = @user.save
        if result === 1
            { message: 'User created successfully', status: 201 }
        else
            result
        end
    end

    def login(request_body)
        user = User.new(request_body)
    end

    def logout(request_body)
        user = User.new(request_body)
    end

    def user(request_body)
        user = User.new(request_body)
    end
end