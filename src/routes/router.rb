class Router
    def initialize(env)
        @routes = env
    end

    def add_route(http_method, path, controller_class, action)
        @routes[http_method] ||= {}
        @routes[http_method][path] = { controller: controller_class, action: action }
    end

    def route(request)
        http_method = request.request_method
        path = request.path_info
        route_info = @routes.dig(http_method, path)

        if route_info
            controller = Object.const_get(route_info[:controller]).new
            action = route_info[:action]
            body, status, headers = controller.send(action, request)
        else
            body, status, headers = [{ message: 'Not Found' }.to_json], 404, { 'Content-Type' => 'application/json' }
        end

        Rack::Response.new(body, status, headers).finish
    end
end