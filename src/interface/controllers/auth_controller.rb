require 'json'
require './src/application/usecase/auth_usecase'
require './src/interface/serializers/serializer'

class AuthController
    def initialize
        pp "===== auth_controller ====="
        @auth_service = AuthUseCase.new
        @serializer = Serializer.new
    end

    def register(request)
        body = JSON.parse(request.body.read)
        res = @auth_service.register(body)
        @serializer.serialize(res)
    end

    def login(request)
        body = JSON.parse(request.body.read)
        res = @auth_service.login(body)
        @serializer.serialize(res)
    end

    def logout(request)
        res = @auth_service.logout(request.get_header('HTTP_AUTHORIZATION'))
        @serializer.serialize(res)
    end

    def user(request)
        res = @auth_service.user(request.get_header('HTTP_AUTHORIZATION'))
        @serializer.serialize(res)
    end
end