require 'json'
require 'dotenv'
require './src/routes/router'

class App

    def call(env)
        p "===== Hello! This is RubyBBDDD!! ====="

        # リクエストの情報を取得
        request = Rack::Request.new(env)

        # ルーティングしてレスポンスの中身を返す
        body, status, headers = Router.new(env).route(request)

        # レスポンス
        Rack::Response.new(body, status, headers).finish
    end
end
