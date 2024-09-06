require 'uri'

class Router
    def initialize(env)
        pp "===== router ====="
    end

    def add_route(http_method, path, controller_class, action)
        path_regex = convert_path_to_regex(path)
        @routes = []
        @routes << { method: http_method, path: path_regex, controller: controller_class, action: action }
    end

    def route(request)
        pp request
        # クエリパラメータを取得
        query_params = request.params

        # 動的ルートにマッチするか確認
        matched_route = @routes.find {
            |route| route[:method] == request.request_method &&
            request.path_info.match(route[:path])
        }

        pp query_params
        pp matched_route

        if matched_route
            controller = Object.const_get(route_info[:controller]).new
            action = route_info[:action]
            body, status, headers = controller.send(action, request)
        else
            body, status, headers = [{ message: 'route not found' }.to_json], 404, { 'Content-Type' => 'application/json' }
        end

        Rack::Response.new(body, status, headers).finish
    end

    private

    # 動的なパスを正規表現に変換
    def convert_path_to_regex(path)
        Regexp.new("^" + path.gsub(/:\w+/, '(?<\0>[^/]+)') + "$")
    end

end
