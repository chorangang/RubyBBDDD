require 'json'
require 'dotenv'
require './src//routes/router'
require './src//routes/routes'
require './src/interface/controllers/auth_controller'

class App
    def call(env)
        p "===== Hello! This is RubyBBDDD!! ====="

        # リクエストの情報を取得
        request = Rack::Request.new(env)

        # ルーティング　　ルートの中身はroutes.rbに記述
        @router = Router.new(env)
        ROUTES.each do |route|
            @router.add_route(route[:method], route[:path], route[:controller], route[:action])
        end
        @router.route(request)
    end
end