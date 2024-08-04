require 'rack'
require 'rack/reloader'
require './src/app'
require './src/middleware/error_handling_middleware'

# .envファイルを読み込む
Dotenv.load

# 例外をキャッチするミドルウェア
use ErrorHandlingMiddleware

use Rack::Reloader, 0

run App.new