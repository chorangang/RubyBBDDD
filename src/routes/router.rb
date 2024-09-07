require './src/routes/routes'
require './src/interface/controllers/auth_controller'
require './src/interface/controllers/users_controller'
require './src/interface/controllers/threads_controller'
require './src/interface/controllers/comments_controller'

class Router
    def initialize(env)
        pp "===== router ====="

        # Routesをクラス変数に格納
        @routes = []
        ROUTES.each do |route|
            @routes << {
                method: route[:method],
                path: convert_path_to_regex(route[:path]),
                controller: route[:controller],
                action: route[:action]
            }
        end
    end

    def route(request)
        http_method = request.request_method
        path = request.path_info

        # 動的ルートにマッチするか確認
        matched_route = @routes.find {|route| route[:method] == http_method && path.match(route[:path])}

        if matched_route

            match_data = path.match(matched_route[:path])

            # マッチしたパラメータを抽出
            route_params = extract_route_params(match_data)

            # クエリパラメータを追加
            query_params = request.params

            # パラメータをマージして一つのハッシュにまとめる
            params = route_params.merge(query_params)

            controller = Object.const_get(matched_route[:controller]).new
            action = matched_route[:action]

            # route_paramsがある場合とない場合で分岐
            if params.empty?
                body, status, headers = controller.send(action, request)
            else
                body, status, headers = controller.send(action, request, params)
            end
        else
            body, status, headers = [{ message: 'route not found' }.to_json], 404, { 'Content-Type' => 'application/json' }
        end
    end

    private

    # 動的なパスを正規表現に変換
    def convert_path_to_regex(path)
        Regexp.new("^" + path.gsub(/:\w+/, '(?<\0>[^/]+)') + "$")
    end

    # マッチしたパラメータを抽出
    def extract_route_params(match_data)
        match_data.names.zip(match_data.captures).to_h
    end
end
