require './src/domain/models/user'
require './src/domain/models/token'
require './src/modules/secrets_loader'
require './src/domain/service/auth_service'
require './src/infrastructure/repository/user_repository'
require './src/infrastructure/repository/token_repository'

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
        if @user_repo.save(@user.to_hash)
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
        # emailでユーザーを検索する
        @user = User.new(@user_repo.findByEmail(request_hash['email']))

        if @user.nil?
            return { message: 'User not found.', status: 404 }
        end

        if @auth_service.verify(request_hash['password'], @user.get_password_value)
            # JWTを生成してDBに保存
            @token = Token.new(user.id)
            @token = @auth_service.generate_token(@token.to_hash)
            @token_repo.save(@token.to_hash)

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
        # JWTがブラックリストにいないか確認
        @auth_service.token_exsits?(jwt)
    end

    # Logs out a user based on the provided JWT.
    #
    # @param jwt [String] The JWT to logout.
    # @return [Hash] The result of the user logout operation.
    #
    def logout(jwt)
        # Tokenを保存してexpired_atを更新し使えなくしてログアウト
        decoded_token = JWT.decode(jwt, SecretsLoader.load.public_key, true, algorithm: 'RS256')
        @token = Token.new(decoded_token.first['user_id'], jwt, Time.now() - 60)
        @token_repo.save(@token.to_hash)

        { message: 'Logout successful', status: 200 }
    end

    # Retrieves user information based on the provided request parameters.
    #
    # @param request_hash [Hash] The request parameters for retrieving user information.
    # @return [User] The user object containing the requested information.
    #
    def user(jwt)
        # JWTをデコードしてユーザーIDなどをエンティティへ
        decoded_token = JWT.decode(jwt, SecretsLoader.load.public_key, true, algorithm: 'RS256')
        @token = Token.new(decoded_token.first['user_id'], jwt, decoded_token.first['expired_at'])

        # ユーザーを取得
        user = @user_repo.find(@token.user_id)

        if user.nil?
            return { message: 'User not found', status: 404 }
        end

        # ユーザーを返す
        {
            id:         user['id'],
            name:       user['name'],
            email:      user['email'],
            created_at: user['created_at'],
            updated_at: user['updated_at']
        }
    end
end