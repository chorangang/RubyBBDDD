require './src/domain/models/user'
require './src/modules/secrets_loader'

class AuthUseCase
    def register(request_hash)
        @user = User.new(request_hash)
        result = @user.save
        if result === 1
            { message: 'User created successfully', status: 201 }
        else
            result
        end
    end

    def login(request_hash)
        user = User.new(request_hash)
        if user.login
            { 
                message: 'Login successful',
                token: generate_token(user.id),
                status: 200
            }
        else
            { message: 'Login failed', status: 401 }
        end
    end

    def logout(request_body)
        user = User.new(request_body)
    end

    def user(request_body)
        user = User.new(request_body)
    end

    private

    def generate_token(user_id)
        # Moduleで秘密鍵を取ってきてJWTを生成する
        secrets = SecretsLoader.load
        JWT.encode({ user_id: user_id }, secrets.private_key, 'RS256')
    end
end