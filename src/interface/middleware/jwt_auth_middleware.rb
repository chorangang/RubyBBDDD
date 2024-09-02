require 'jwt'
require 'json'
require './src/routes/routes'
require './src/application/usecase/auth_usecase'

class JwtAuthMiddleware
  def initialize(app)
    pp "===== jwt_auth_middleware ====="
    @app = app
    @skip_paths = SKIP_PATHS
    @auth_usecase = AuthUseCase.new
  end

  def call(env)
    # 認証をスキップするパスかどうかを判定
    pp "===== jwt auth start ====="
    request = Rack::Request.new(env)
    path = request.path_info

    # 認証をスキップするパスの場合はそのまま次のミドルウェアまたはアプリケーションに処理を渡す
    if @skip_paths.include?(path)
      pp "===== this request from skip paths. ====="
      return @app.call(env)
    end
    
    # Tokenを取得
    token = env['HTTP_AUTHORIZATION']
    unless token
      pp "===== http_authorization is nil. ====="
      return unauthorized_response
    end

    # # Bearerトークンを取得
    # bearer, token = authorization.split(' ')
    # unless bearer == 'Bearer'
    #   pp "===== bearer token is nil. ====="
    #   return unauthorized_response
    # end
    
    # JWTトークンを検証
    begin
      pp "===== check if JWT is correct. ====="

      # JWTトークンを検証
      decoded = JWT.decode(token, ENV['HMAC_SECRET'], true, { algorithm: 'HS256' })

      # expired_at = Time.new(decoded[0]['expired_at'])

      # # トークンの有効期限を確認
      # if expired_at < Time.now
      #   pp "===== token is expire. ====="
      #   return unauthorized_response(msg: 'Token expired')
      # end

      # 認証済みのTokenか、期限切れでないかを確認
      if !@auth_usecase.authenticate(token)
        pp "===== this token " + token + " is registered in BlackList."
        return unauthorized_response(msg: 'Token is invalid')
      end
    rescue JWT::DecodeError
      pp "===== this token is incorrect. ====="
      return unauthorized_response
    end

    pp "===== this token is authenticated. ====="
    @app.call(env)
  end

  private

  def unauthorized_response(msg: 'Unauthorized')
    return [401, { 'Content-Type' => 'application/json' }, [{ message: msg }.to_json]]
  end
end
