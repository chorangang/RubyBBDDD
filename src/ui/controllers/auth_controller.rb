require 'json'
require './src/application/usecase/auth_service'
require './src/ui/serializers/serializer'

class AuthController
    def initialize
        @auth_service = AuthService.new
        @serializer = Serializer.new
    end

    def register(request)
        body = JSON.parse(request.body.read)
        res = @auth_service.register(body)
        @serializer.serialize(res)
    end
end