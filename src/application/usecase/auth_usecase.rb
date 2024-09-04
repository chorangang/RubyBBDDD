require './src/domain/models/user'
require './src/domain/models/token'
require './src/domain/service/auth_service'
require './src/infrastructure/repository/user_repository'
require './src/infrastructure/repository/token_repository'
require './src/application/dto/user_data'
require './src/application/dto/token_data'

class AuthUseCase
    # Initializes a new instance of the AuthUseCase class.
    def initialize
        pp "===== auth_usecase ====="
        @auth_service = AuthService.new
        @user_repo = UserRepository.new
        @token_repo = TokenRepository.new
    end

    # Registers a new user.
    #
    # @param request_hash [Hash] The request parameters for user registration.
    # @return [Hash] The result of the user registration operation.
    #
    def register(request_hash)
        # リクエストからユーザーを一人インスタンス化
        @user = User.new(request_hash)

        # パスワードをハッシュ化
        @user = @auth_service.passwrod_hash(@user)

        # ユーザーを保存成功で200、失敗で400
        if @user_repo.save(UserData.from_entity(@user))
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
        pp request_hash
        pp req
        # emailでユーザーを検索する
        pp @user_repo.findByEmail(request_hash['email'])
        @user = User.new(@user_repo.findByEmail(request_hash['email']))

        if @user.nil?
            return { message: 'User not found.', status: 404 }
        end

        if @auth_service.verify(request_hash['password'], @user.get_password_value)
            # JWTを生成してDBに保存
            @token = Token.new(@user.id)
            @token = @auth_service.generate_token(@token)
            @token_repo.save(TokenData.from_entity(@token))

            #JWTをつけてLogin成功メッセージを返す
            return {
                message: 'Login successful',
                token:   @token.value,
                status:  200
            }
        end

        return { message: 'Login failed', status: 401 }
    end

    # Logs out a user based on the provided JWT.
    #
    # @param jwt [String] The JWT to logout.
    # @return [Hash] The result of the user logout operation.
    #
    def logout(token)
        # Tokenを削除してログアウト処理を行う
        if !@token_repo.delete(token)
            return { message: 'Logout failed', status: 400 }
        end

        { message: 'Logout successful', status: 200 }
    end

    # Retrieves user information based on the provided request parameters.
    #
    # @param request_hash [Hash] The request parameters for retrieving user information.
    # @return [User] The user object containing the requested information.
    #
    def user(token)
        # JWTをデコード
        decoded_token = JWT.decode(token, ENV['HMAC_SECRET'], true, { algorithm: 'HS256' })

        # ユーザーを取得
        @user = User.new(@user_repo.find(decoded_token.first['user_id']))

        if @user.nil?
            return { message: 'User not found', status: 404 }
        end

        # ユーザーを返す
        UserData.from_entity(@user).serialize_to_hash
    end

    # Authenticates a user based on the provided JWT.
    #
    # @param jwt [String] The JWT to authenticate.
    # @return [Boolean] True if the JWT is valid and not expired, false otherwise.
    #
    def authenticate(token)
        # トークンがあるか確認
        result = @token_repo.find(token)

        if result.nil?
            return false
        end

        @token = Token.new(result)

        # トークンの有効期限を確認
        if @token.expired_at < Time.now
            return false
        end

        true
    end
end
