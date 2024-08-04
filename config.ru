require 'rack'
require 'rack/reloader'
require './src/app'
require './src/interface/middleware/error_handling_middleware'
require './src/interface/middleware/jwt_auth_middleware'

# リロードのためのミドルウェア
use Rack::Reloader, 0

# .envファイルを読み込む
Dotenv.load

# 例外をキャッチするミドルウェア
use ErrorHandlingMiddleware

# JWT認証のためのミドルウェア
use JwtAuthMiddleware

run App.new