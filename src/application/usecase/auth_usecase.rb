require './src/domain/models/user'
require './src/domain/models/token'
require './src/domain/service/token_service'
require './src/modules/secrets_loader'

class AuthUseCase
    def initialize
        pp "===== auth_usecase ====="
        @token_service = TokenService.new
    end

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
            # JWTを生成してDBに保存
            @token = Token.new(user.id)
            @token = @token_service.generate_token(@token)
            @token_service.save(@token)

            #JWTをつけてLogin成功メッセージを返す
            { 
                message: 'Login successful',
                token: @token.value,
                status: 200
            }
        else
            { message: 'Login failed', status: 401 }
        end
    end

    def authenticate(jwt)
        # Tokenを検証して有効期限を確認
        @token_service.exists?(jwt)
    end    

    def logout(jwt)
        # Tokenを保存してexpired_atを更新し使えなくしてログアウト
        decoded_token = JWT.decode(jwt, SecretsLoader.load.public_key, true, algorithm: 'RS256')
        token = Token.new(decoded_token.first['user_id'], jwt, Time.now() - 60)
        @token_service.save(token)

        { message: 'Logout successful', status: 200 }
    end

    def user(request_body)
        user = User.new(request_body)
    end
end