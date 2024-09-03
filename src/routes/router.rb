class Router
    def initialize(env)
        pp "===== router ====="
        @routes = env
    end

    def add_route(http_method, path, controller_class, action)
        path_regex = path_to_regex(path)
        @routes[http_method] ||= []
        @routes[http_method] << { regex: path_regex, controller: controller_class, action: action, path: path }
    end

    def route(request)
        http_method = request.request_method
        path = request.path_info
        pp "http_method: #{http_method}"
        pp "path: #{path}"

        route_info = find_route(http_method, path)

        if route_info
            controller = Object.const_get(route_info[:controller]).new
            action = route_info[:action]
            path_params = extract_path_params(route_info[:path], path)
            body, status, headers = controller.send(action, request, path_params)
        else
            body = [{ message: 'route not found' }.to_json],
            status = 404,
            headers = { 'Content-Type' => 'application/json' }
        end

        Rack::Response.new(body, status, headers).finish
    end

    private

    def path_to_regex(path)
        Regexp.new("^" + path.gsub(/:\w+/, '(\\w+)') + "$")
    end

    def find_route(http_method, path)
        @routes[http_method]&.find { |route| path.match(route[:regex]) }
    end

    def extract_path_params(route_path, path)
        param_names = route_path.scan(/:(\w+)/).flatten
        param_values = path.match(path_to_regex(route_path)).captures
        param_names.zip(param_values).to_h
    end
end
