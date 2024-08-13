require './src/domain/models/user'
require './src/domain/models/token'
require './src/domain/service/token_service'
require './src/modules/secrets_loader'

class AuthUseCase
    # Initializes a new instance of the AuthUseCase class.
    def initialize
        pp "===== auth_usecase ====="
        @auth_service = AuthService.new
        @token_service = TokenService.new
        @user_repo = UserRepository.new
    end

    # Registers a new user.
    #
    # @param request_hash [Hash] The request parameters for user registration.
    # @return [Hash] The result of the user registration operation.
    #
    def register(request_hash)
        @user = User.new(request_hash)

        # 値オブジェクトから値を取り出す
        @user.set_values(password_hashing: true)

        # ユーザーを保存して成功失敗で真偽値が返る
        result = @repo.save(@user)

        if result === true
            return { message: 'User created successfully', status: 201 }
        end

        return { message: 'User creation failed', status: 400 }
    end

    # Login a user.
    #
    # @param request_hash [Hash] The request parameters for user login.
    # @return [Hash] The result of the user login operation.
    #
    def login(request_hash)
        @user = User.new(request_hash)

        # 値オブジェクトから値を取り出す
        @user.set_values(password_hashing: false)

        @user = @repo.find(@user)

        if @auth_service.verify(@password, user['password'])
            # JWTを生成してDBに保存
            @token = Token.new(user.id)
            @token = @token_service.generate_token(@token)
            @token_repo.save(@token)

            #JWTをつけてLogin成功メッセージを返す
            return { 
                message: 'Login successful',
                token:   @token.value,
                status:  200
            }
        end

        return { message: 'Login failed', status: 401 }
    end

    # Authenticates a user based on the provided JWT.
    #
    # @param jwt [String] The JWT to authenticate.
    # @return [Boolean] True if the JWT is valid and not expired, false otherwise.
    #
    def authenticate(jwt)
        # Tokenを検証して有効期限を確認
        @token_service.exists?(jwt)
    end

    # Logs out a user based on the provided JWT.
    #
    # @param jwt [String] The JWT to logout.
    # @return [Hash] The result of the user logout operation.
    #
    def logout(jwt)
        # Tokenを保存してexpired_atを更新し使えなくしてログアウト
        decoded_token = JWT.decode(jwt, SecretsLoader.load.public_key, true, algorithm: 'RS256')
        token = Token.new(decoded_token.first['user_id'], jwt, Time.now() - 60)
        @token_service.save(token)

        { message: 'Logout successful', status: 200 }
    end

    # Retrieves user information based on the provided request parameters.
    #
    # @param request_hash [Hash] The request parameters for retrieving user information.
    # @return [User] The user object containing the requested information.
    #
    def user(request_hash)
        user = User.new(request_body)

        # 値オブジェクトから値を取り出す
        user.set_values(password_hashing: false)

        # ユーザーを取得
        user = @repo.findById(user)

        if user.nil?
            return { message: 'User not found', status: 404 }
        end

        # ユーザー情報を返す
        {
            id:         user['id'],
            name:       user['name'],
            email:      user['email'],
            created_at: user['created_at'],
            updated_at: user['updated_at']
        }
    end
end